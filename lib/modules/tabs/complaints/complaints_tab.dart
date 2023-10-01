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

class ComplaintsTab extends StatelessWidget {
  const ComplaintsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
      child: Column(
        children: [
          SizedBox(height: AppConstants.topPadding),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.faqScreen);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadius)),
              child: Center(
                child: Text(
                  'الأسئلة الأكثر شيوعاً',
                  style:
                      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          PrimaryTextField(
            hintText: 'تفاصيل الشكوى أو الاقتراح',
            maxLines: 8,
          ),
          SizedBox(height: 15.h),
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
                  "اضغط هنا لرفع صورة توضيحية",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 18.h),
                SvgPicture.asset(AppImages.gallery,
                    height: 80.h, fit: BoxFit.scaleDown),
              ],
            ),
          ),
          const Spacer(),
          PrimaryButton(onTap: () {}, text: 'رفع الشكوى او الاقتراح'),
          SizedBox(height: 25.h),
        ],
      ),
    );
  }
}
