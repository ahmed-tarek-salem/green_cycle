import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/main.dart';
import 'package:green_cycle/models/request_models/sign_up_request_model.dart';
import 'package:green_cycle/models/response_models/user_response_model.dart';
import 'package:green_cycle/modules/sign_up/sign_up_repo.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';
import 'package:image_picker/image_picker.dart';

class SignUpController extends BaseController {
  final _repo = SignUpRepo();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final gender = Gender.male.obs;
  final errorMessage = RxString('');
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  Rx<XFile?> image = Rx(null);

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 400), () {
      checkIfSigned();
    });
    super.onInit();
  }

  Future<void> signUp() async {
    if (!signUpFormKey.currentState!.validate()) {
      return;
    }
    if (image.value == null) {
      showErrorDialog('برجاء رفع كارنيه كلية صيدلة الخاص بك');
      return;
    }
    try {
      showLoadingOverlay();
      final signUpRequestModel = SignUpRequestModel(
          name: nameController.text,
          phone: phoneController.text,
          gender: gender.value == Gender.male ? 'male' : 'female',
          password: passwordController.text,
          passwordConfirm: passwordController.text,
          image: dio.MultipartFile.fromFileSync(image.value!.path));
      final UserResponseModel userResponseModel =
          await _repo.signUp(signUpRequestModel);
      // DioClient.login(userResponseModel.token);
      // await _repo.verifyOtp();
      if (userResponseModel.data.isVerified != true) {
        Get.toNamed(AppRoutes.successs, arguments: () {
          Get.offAllNamed(AppRoutes.loginScreen);
        });
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

  keepLogged(String token) {
    DioClient.login(token);
    localStorage.setToken(token);
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

  checkIfSigned() async {
    if (localStorage.getToken() != null) {
      await keepLogged(localStorage.getToken()!);
      Get.offNamed(AppRoutes.homeLayoutScreen);
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
