import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const DrawerTile({
    required this.onTap,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(20.w, 0, 10.w, 10.h),
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 20.sp),
        decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
        child: Text(
          title,
          style: Get.textTheme.headlineSmall!.copyWith(),
        ),
      ),
    );
  }
}
