import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'app_colors.dart';

class AppThemes {
  /// Rounded shape ************************************************************
  static var shape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

  lightThemeData(String locale) {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.white,
      fontFamily:
          locale == 'ar' ? AppConstants.montserratAr : AppConstants.spEn,
      cardColor: AppColors.white,
      primaryColor: AppColors.primary,
      indicatorColor: AppColors.primary,
      inputDecorationTheme: InputDecorationTheme(
        errorMaxLines: 2,
        fillColor: AppColors.secondary,
        hintStyle: Get.textTheme.bodyMedium,
        labelStyle: Get.textTheme.bodyMedium,
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular((AppConstants.borderRadius))),
            borderSide: const BorderSide(
              color: AppColors.secondary,
            )),
        border: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(AppConstants.borderRadius)),
            borderSide: BorderSide(
              color: AppColors.greyD5.withOpacity(0.5),
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(AppConstants.borderRadius)),
            borderSide: BorderSide(
              color: AppColors.greyD5.withOpacity(0.5),
            )),
        disabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(AppConstants.borderRadius)),
            borderSide: BorderSide(
              color: AppColors.greyD5.withOpacity(0.5),
            )),
      ),
      appBarTheme: const AppBarTheme(
          color: AppColors.white,
          iconTheme: IconThemeData(color: AppColors.white)),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: AppColors.primary,
          fontSize: 18.sp,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w400,
          fontSize: 12.sp,
        ),
        headlineLarge: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 16.sp,
        ),
        headlineMedium: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
        ),
        headlineSmall: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
        ),
        displayLarge: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 14.sp,
        ),
        displayMedium: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
        displaySmall: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
        ),
        bodyLarge: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
        ),
        bodyMedium: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w400,
          fontSize: 12.sp,
        ),
        bodySmall: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w300,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}
