import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/request_models/activity_request_model.dart';
import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';
import 'package:green_cycle/modules/action/action_repo.dart';
import 'package:green_cycle/modules/action/activity_submission.dart';
import 'package:green_cycle/modules/rewards/rewards_repo.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/global/points_label.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';
import 'package:image_picker/image_picker.dart';

/// Two-step submission: pick an activity from the server's catalog, then
/// send the proof for it. Points and cooldowns are decided by the server.
class ActionController extends BaseController {
  final _repo = ActionRepo();
  final _rewardsRepo = Get.find<RewardsRepo>();
  final TextEditingController actionDetailsController = TextEditingController();

  final RxList<RewardAction> actions = <RewardAction>[].obs;

  /// Activities with a request still under review, locked in the picker.
  final RxSet<String> pendingSlugs = <String>{}.obs;
  final Rxn<RewardAction> selectedAction = Rxn();
  final RxnString variantKey = RxnString();
  final RxInt units = 1.obs;

  XFile? image;
  RxInt imageKeyIndex = 0.obs;

  @override
  void onInit() {
    loadActions();
    super.onInit();
  }

  Future<void> loadActions() async {
    try {
      setLoading = true;
      final myRewards = _loadPendingSlugs();
      final catalog = await _rewardsRepo.getCatalog();
      await myRewards;
      actions.assignAll(catalog.actions.where((a) => a.isStudentSubmittable));
      setError = false;
    } catch (e) {
      setError = true;
      final exceptionMessage =
          (e is MyCustomException) ? e.message : AppConstants.error;
      showErrorDialog(exceptionMessage);
    } finally {
      setLoading = false;
    }
  }

  /// Best effort: without it every activity stays open, and the server still
  /// refuses a second pending request with a clear message.
  Future<void> _loadPendingSlugs() async {
    try {
      final myRewards = await _rewardsRepo.getMyRewards();
      pendingSlugs.assignAll(myRewards.pendingSlugs);
    } catch (_) {}
  }

  void selectAction(RewardAction action) {
    selectedAction.value = action;
    _resetForm();
  }

  /// Back to the activity list.
  void clearSelection() {
    selectedAction.value = null;
    _resetForm();
  }

  void selectVariant(String key) {
    variantKey.value = key;
    update();
  }

  void setUnits(int value) {
    units.value = value;
    update();
  }

  void _resetForm() {
    variantKey.value = null;
    units.value = 1;
    clearControllers();
  }

  Future<void> submitAction() async {
    final action = selectedAction.value;
    final details = actionDetailsController.text.trim();
    final problem = validateSubmission(
      action: action,
      variantKey: variantKey.value,
      hasImage: image != null,
      details: details,
    );
    if (action == null || problem != null) {
      showErrorDialog(problem ?? AppConstants.error);
      return;
    }

    try {
      showLoadingOverlay();
      final activityRequestModel = ActivityRequestModel(
        type: 'action',
        summary: details,
        details: details,
        rewardActionSlug: action.slug,
        variantKey:
            action.pointsMode == PointsMode.variants ? variantKey.value : null,
        units: action.pointsMode == PointsMode.perUnit ? units.value : null,
        image:
            image == null ? null : dio.MultipartFile.fromFileSync(image!.path),
      );
      final points = await _repo.submitAction(activityRequestModel);

      final reward = points != null && points > 0
          ? 'ستحصل على ${pointsLabel(points)}'
          : 'سوف تحصل على نقاطك الخضراء';
      showSuccessDialog(
        'تم إرسال مشاركتك بنجاح',
        'نشكرك على تفاعلك معنا، بمجرد قبول مشاركتك $reward!',
        onTap: () {
          Get.back();
          Get.back();
        },
      );
    } catch (e) {
      if (e is MyCustomException) {
        showErrorDialog(submitErrorMessage(e.message, action, code: e.code));
        if (e.code == 'PENDING_SAME_ACTION') {
          // Sent from another device, or the list loaded before it.
          pendingSlugs.add(action.slug);
          clearSelection();
        }
        if (isInactiveActionError(e.message, code: e.code)) {
          // The college switched it off since the list loaded.
          clearSelection();
          loadActions();
        }
      } else {
        showErrorDialog(AppConstants.error);
      }
    } finally {
      hideLoadingOverlay();
    }
  }

  void clearControllers() {
    actionDetailsController.clear();
    image = null;
    imageKeyIndex.value++;
    update();
  }

  @override
  void onClose() {
    actionDetailsController.dispose();
    super.onClose();
  }
}
