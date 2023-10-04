import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/request_models/activity_request_model.dart';
import 'package:green_cycle/modules/tabs/complaints/complaints_repo.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class ComplaintsController extends BaseController {
  final _repo = ComplaintsRepo();
  final TextEditingController complaintDetailsController =
      TextEditingController();
  final TextEditingController complaintTitleController =
      TextEditingController();
  XFile? image;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxInt imageKeyIndex = 0.obs;

  submitComplaint() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    print(image);

    try {
      showLoadingOverlay();
      final activityRequestModel = ActivityRequestModel(
          type: 'suggestion',
          summary: complaintTitleController.text,
          details: complaintDetailsController.text,
          points: 20,
          image: image == null
              ? null
              : dio.MultipartFile.fromFileSync(image!.path));
      print(activityRequestModel.toMap());
      await _repo.submitComplaint(activityRequestModel);
      showSuccessDialog('تم إرسال رسالتك بنجاح',
          'نشكرك على تفاعلك معنا وسيتم النظر في طلبك في أقرب وقت');
      clearControllers();
    } catch (e) {
      print(e);
      final exceptionMessage =
          (e is MyCustomException) ? e.message : AppConstants.error;
      showErrorDialog(exceptionMessage);
    } finally {
      hideLoadingOverlay();
    }
  }

  clearControllers() {
    complaintTitleController.clear();
    complaintDetailsController.clear();
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
