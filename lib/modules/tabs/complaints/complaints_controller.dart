import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/request_models/feedback_request_model.dart';
import 'package:green_cycle/modules/tabs/complaints/complaints_repo.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

/// Suggestions and notes about the app, carpooling or anything else. They go
/// to the feedback page of the dashboard and earn no points.
class ComplaintsController extends BaseController {
  final _repo = ComplaintsRepo();
  final TextEditingController complaintDetailsController =
      TextEditingController();
  final TextEditingController complaintTitleController =
      TextEditingController();
  final Rx<FeedbackType> type = FeedbackType.app.obs;
  XFile? image;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxInt imageKeyIndex = 0.obs;

  Future<void> submitComplaint() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      showLoadingOverlay();
      await _repo.submitFeedback(
        FeedbackRequestModel(
          type: type.value,
          title: complaintTitleController.text.trim(),
          details: complaintDetailsController.text.trim(),
          image: image == null
              ? null
              : dio.MultipartFile.fromFileSync(image!.path),
        ),
      );
      showSuccessDialog('تم إرسال رسالتك بنجاح',
          'نشكرك على تفاعلك معنا وسيتم النظر في طلبك في أقرب وقت');
      clearControllers();
    } catch (e) {
      final exceptionMessage = (e is MyCustomException)
          ? feedbackErrorMessage(e.message, code: e.code)
          : AppConstants.error;
      showErrorDialog(exceptionMessage);
    } finally {
      hideLoadingOverlay();
    }
  }

  void clearControllers() {
    complaintTitleController.clear();
    complaintDetailsController.clear();
    type.value = FeedbackType.app;
    image = null;
    imageKeyIndex.value++;
    update();
  }

  @override
  void onClose() {
    complaintDetailsController.dispose();
    complaintTitleController.dispose();
    super.onClose();
  }
}
