import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/prompts_response_model.dart';
import 'package:green_cycle/modules/home_layout/home_layout_controller.dart';
import 'package:green_cycle/modules/prompts/prompts_repo.dart';
import 'package:green_cycle/modules/prompts/widgets/prompt_dialog.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

enum _TripAnswer { yes, no, later }

/// Shows what the server says needs the student's attention, one at a time:
/// a request the admin reviewed, or a carpool trip to confirm. Checked when
/// the home screen loads and whenever the app comes back to the foreground.
class PromptsController extends BaseController with WidgetsBindingObserver {
  final _repo = PromptsRepo();
  bool _showing = false;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) checkPrompts();
  }

  Future<void> checkPrompts() async {
    // Only over the home screen, so a prompt never interrupts a form.
    if (_showing || Get.currentRoute != AppRoutes.homeLayoutScreen) return;
    if (DioClient.isHandlingSessionExpiry) return;
    _showing = true;
    try {
      final prompts = await _repo.getPrompts();
      for (final prompt in prompts) {
        final keepGoing = switch (prompt) {
          ActivityReviewedPrompt() => await _showReview(prompt),
          CarpoolConfirmPrompt() => await _askTrip(prompt),
        };
        if (!keepGoing) break;
      }
    } catch (e) {
      // Prompts come back on the next check, so a failure is not shown.
      debugPrint('Could not load prompts: $e');
    } finally {
      _showing = false;
    }
  }

  Future<bool> _showReview(ActivityReviewedPrompt prompt) async {
    await Get.dialog<bool>(
      PromptDialog<bool>(
        icon: prompt.approved ? Icons.check_circle_outline : Icons.info_outline,
        title: prompt.title,
        body: prompt.body,
        actions: const [PromptAction('حسناً', true, primary: true)],
      ),
      barrierDismissible: false,
    );
    try {
      await _repo.markSeen(prompt.id);
    } catch (e) {
      debugPrint('Could not mark prompt seen: $e');
    }
    if (prompt.approved) _refreshHomePoints();
    return true;
  }

  Future<bool> _askTrip(CarpoolConfirmPrompt prompt) async {
    final answer = await Get.dialog<_TripAnswer>(
      PromptDialog<_TripAnswer>(
        icon: Icons.directions_car_outlined,
        title: prompt.title,
        body: prompt.body,
        actions: const [
          PromptAction('نعم، تمت الرحلة', _TripAnswer.yes, primary: true),
          PromptAction('لا، لم تتم', _TripAnswer.no),
          PromptAction('لاحقاً', _TripAnswer.later),
        ],
      ),
      barrierDismissible: false,
    );
    if (answer == null || answer == _TripAnswer.later) return false;

    final rode = answer == _TripAnswer.yes;
    try {
      final result = await _repo.confirmTrip(prompt.tripId, rode: rode);
      await showSuccessDialog(
        rode ? 'شكراً لتأكيدك' : 'تم تسجيل ردك',
        tripConfirmResultText(
          rode: rode,
          awaitingOther: result.awaitingOther,
          points: result.points,
        ),
      );
      if (result.points > 0) _refreshHomePoints();
    } on MyCustomException catch (e) {
      // Already answered or closed elsewhere: nothing left to ask.
      debugPrint('Could not confirm trip: ${e.code} ${e.message}');
    }
    return true;
  }

  void _refreshHomePoints() {
    if (Get.isRegistered<HomeLayoutController>()) {
      Get.find<HomeLayoutController>().loadRewards();
    }
  }
}
