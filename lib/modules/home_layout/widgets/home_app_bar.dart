import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/theme/app_colors.dart';

AppBar returnHomeAppBar(String title) {
  return AppBar(
    backgroundColor: AppColors.primary,
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.sp),
    ),
  );
}
