import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/login/login_controller.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/shared_widgets/primary_text_field.dart';
import 'package:green_cycle/theme/app_images.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              SizedBox(height: 50.h),
              Center(child: Image.asset(AppImages.loginVector)),
              SizedBox(height: 20.h),
              PrimaryTextField(
                hintText: 'رقم الهاتف',
                controller: controller.phoneController,
              ),
              SizedBox(height: 10.h),
              PrimaryTextField(
                hintText: 'كلمة المرور',
                isObscured: true,
                controller: controller.passwordController,
              ),
              SizedBox(height: 50.h),
              PrimaryButton(
                  onTap: () {
                    controller.login();
                  },
                  text: 'تسجيل الدخول'),
              SizedBox(height: 14.h),
              GestureDetector(
                  onTap: () {
                    Get.offAndToNamed(AppRoutes.signUpScreen);
                  },
                  child: const Text('ليس لديك حساب؟ إنشاء حساب')),
            ],
          ),
        ),
      ),
    );
  }
}
