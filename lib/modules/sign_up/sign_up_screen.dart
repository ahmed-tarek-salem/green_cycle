import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/shared_widgets/primary_text_field.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/theme/app_images.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding:
            EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),
            Center(
              child: Image.asset(
                AppImages.logoPng,
                height: 150.h,
              ),
            ),
            SizedBox(height: 12.h),
            PrimaryTextField(hintText: 'الاسم'),
            SizedBox(height: 10.h),
            PrimaryTextField(hintText: 'رقم التليفون'),
            SizedBox(height: 10.h),
            PrimaryTextField(hintText: 'كلمة السر'),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('النوع:'),
                SizedBox(width: 20.w),
                const Text('ذكر'),
                SizedBox(width: 10.w),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 10.sp,
                  child: CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: 9.sp,
                  ),
                ),
                SizedBox(width: 20.w),
                const Text('أنثى'),
                SizedBox(width: 10.w),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 10.sp,
                  child: CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: 9.sp,
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 8.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              height: 160.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.greyVeryLighF5,
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  const Text(
                    "التقط صورة للكارنيه الجامعي الخاص بك",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  const Text(
                    "(كلية صيدلة جامعة الاسكندرية)",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 18.h),
                  SvgPicture.asset(AppImages.gallery,
                      height: 80.h, fit: BoxFit.scaleDown),
                ],
              ),
            ),
            SizedBox(height: 25.h),
            PrimaryButton(onTap: () {}, text: 'تسجيل الدخول'),
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
    );
  }
}
