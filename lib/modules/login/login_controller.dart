import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/request_models/login_request_model.dart';
import 'package:green_cycle/models/response_models/user_response_model.dart';
import 'package:green_cycle/modules/login/login_repo.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/mixins/overlay_mixin.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class LoginController extends GetxController with OverlyaysMixin {
  final _repo = LoginRepo();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      showLoadingOverlay();
      final loginRequestModel = LoginRequestModel(
          phone: phoneController.text, password: passwordController.text);
      final UserResponseModel userResponseModel =
          await _repo.login(loginRequestModel);
      if (userResponseModel.data.isVerified != true) {
        Get.toNamed(AppRoutes.successs);
      } else {
        Get.offAndToNamed(AppRoutes.homeLayoutScreen);
      }
    } catch (e) {
      final exceptionMessage =
          (e is MyCustomException) ? e.message : AppConstants.error;
      showErrorDialog(exceptionMessage);
    } finally {
      hideLoadingOverlay();
    }
  }
}
