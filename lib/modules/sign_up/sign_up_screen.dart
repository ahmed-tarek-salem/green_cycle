import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/sign_up/sign_up_controller.dart';
import 'package:green_cycle/modules/sign_up/widgets/gender_section.dart';
import 'package:green_cycle/modules/sign_up/widgets/id_section.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/shared_widgets/primary_text_field.dart';
import 'package:green_cycle/theme/app_images.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';

class SignupScreen extends GetView<SignUpController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding:
            EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
        child: Form(
          key: controller.signUpFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              Center(
                child: Image.asset(AppImages.logoPng, height: 150.h),
              ),
              SizedBox(height: 12.h),
              PrimaryTextField(
                hintText: 'الاسم',
                controller: controller.nameController,
                validator: FormBuilderValidators.required(),
              ),
              SizedBox(height: 10.h),
              PrimaryTextField(
                  hintText: 'رقم الهاتف',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(11,
                        errorText: "رقم هاتف غير صحيح"),
                    FormBuilderValidators.maxLength(11),
                  ]),
                  controller: controller.phoneController),
              SizedBox(height: 10.h),
              PrimaryTextField(
                  hintText: 'كلمة المرور',
                  isObscured: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(8,
                        errorText:
                            "لا يجب أن تقل كلمة المرور عن ٨ عناصر على الأقل"),
                    FormBuilderValidators.maxLength(50),
                  ]),
                  controller: controller.passwordController),
              SizedBox(height: 15.h),
              GenderSection(controller: controller),
              SizedBox(height: 16.h),
              IdSection(controller: controller),
              SizedBox(height: 25.h),
              PrimaryButton(
                  onTap: () {
                    controller.signUp();
                  },
                  text: 'إنشاء حساب'),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.loginScreen);
                },
                child: const Text('هل لديك حساب بالفعل؟ تسجيل الدخول'),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}
