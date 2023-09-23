import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/sign_up/sign_up_controller.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/theme/app_images.dart';

class IdSection extends StatelessWidget {
  const IdSection({
    super.key,
    required this.controller,
  });

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (_) {
          return GestureDetector(
            onTap: () {
              controller.openGallery();
            },
            child: Container(
              height: 160.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.greyVeryLighF5,
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: controller.image.value != null
                  ? Image.file(File(controller.image.value!.path))
                  : Column(
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
          );
        });
  }
}
