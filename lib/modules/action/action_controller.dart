import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/request_models/activity_request_model.dart';
import 'package:green_cycle/modules/action/action_repo.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class ActionController extends BaseController {
  final _repo = ActionRepo();
  final TextEditingController actionDetailsController = TextEditingController();
  XFile? image;
  RxInt imageKeyIndex = 0.obs;
  submitAction() async {
    if (image == null) {
      showErrorDialog('برجاء رفع الصورة أولاً');
      return;
    }

    try {
      showLoadingOverlay();
      final activityRequestModel = ActivityRequestModel(
          type: 'action',
          summary: actionDetailsController.text,
          details: actionDetailsController.text,
          points: 20,
          image: image == null
              ? null
              : dio.MultipartFile.fromFileSync(image!.path));
      await _repo.submitAction(activityRequestModel);

      showSuccessDialog('تم إرسال مشاركتك بنجاح',
          'نشكرك على تفاعلك معنا، بمجرد قبول مشاركتك سوف تحصل على ٥ نقاط خضراء جديدة!',
          onTap: () {
        Get.back();
        Get.back();
      });
    } catch (e) {
      final exceptionMessage =
          (e is MyCustomException) ? e.message : AppConstants.error;
      showErrorDialog(exceptionMessage);
    } finally {
      hideLoadingOverlay();
    }
  }

  clearControllers() {
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
