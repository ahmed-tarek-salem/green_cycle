import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:green_cycle/models/request_models/sign_up_request_model.dart';
import 'package:green_cycle/modules/sign_up/sign_up_repo.dart';
import 'package:green_cycle/utilities/mixins/loading_overlay_mixin.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';
import 'package:image_picker/image_picker.dart';

class SignUpController extends GetxController with LoadingOverlayMixin {
  final _repo = SignUpRepo();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final gender = Gender.male.obs;
  final errorMessage = RxString('');
  final formKey = GlobalKey<FormState>();
  Rx<XFile?> image = Rx(null);

  Future<void> signUp() async {
    try {
      final signUpRequestModel = SignUpRequestModel(
        name: nameController.text,
        phone: phoneController.text,
        gender: gender.value == Gender.male ? 'male' : 'female',
        password: passwordController.text,
        passwordConfirm:
            passwordController.text, // You can change this if needed.
      );
      showLoadingOverlay();
      await _repo.signUp(signUpRequestModel);
      Get.offAndToNamed(AppRoutes.homeLayoutScreen);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      hideLoadingOverlay();
    }
  }

  setGender(Gender gender) {
    this.gender.value = gender;
    update(['gender']);
  }

  openGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      this.image.value = image;
      update();
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

enum Gender { male, female }
