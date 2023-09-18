import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final String text;
  final bool? isLoading;
  final VoidCallback? onTap;
  const PrimaryButton({
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.isLoading,
    required this.onTap,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46.h,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                backgroundColor ?? AppColors.primary),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.sp),
                    side:
                        BorderSide(color: borderColor ?? AppColors.primary)))),
        onPressed: onTap,
        child: isLoading == true
            ? CustomProgressIndicator(
                color: Colors.white,
                size: 30.sp,
              )
            : Text(
                text,
                style: Get.textTheme.bodyMedium!
                    .copyWith(color: textColor ?? AppColors.white),
              ),
      ),
    );
  }
}
