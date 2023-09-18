import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class PrimaryTextField extends StatelessWidget {
  final String? icon;
  final String hintText;
  final TextEditingController? controller;
  final bool? isObscured;
  final double? bottomPadding;
  final Color? filledColor;
  final bool? enabled;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool autoFocus;
  final Color? hintColor;
  final Color? activeTextAndBorderColor;
  const PrimaryTextField({
    this.isObscured,
    this.icon,
    this.filledColor,
    this.bottomPadding,
    this.enabled = true,
    required this.hintText,
    this.autoFocus = false,
    this.controller,
    this.suffixIcon,
    this.onTap,
    this.validator,
    this.maxLines = 1,
    this.hintColor,
    this.activeTextAndBorderColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Get.locale!.languageCode == 'ar';
    return TextFormField(
      obscureText: isObscured ?? false,
      enabled: enabled,
      obscuringCharacter: '●',
      controller: controller,
      autofocus: autoFocus,
      onTap: onTap,
      validator: validator,
      maxLines: maxLines,
      style: Get.textTheme.bodyMedium,
      decoration: InputDecoration(
        // errorMaxLines: 2,
        fillColor: filledColor ?? AppColors.secondary,
        hintStyle: Get.textTheme.bodyMedium,
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular((AppConstants.borderRadius))),
            borderSide: BorderSide(
              color: activeTextAndBorderColor ?? AppColors.secondary,
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
        prefixIcon: icon == null
            ? null
            : Padding(
                padding: EdgeInsets.only(
                    right: isArabic ? 14.w : 0, left: isArabic ? 0 : 14.w),
                child: SvgPicture.asset(
                  icon!,
                  fit: BoxFit.scaleDown,
                  color: hintColor,
                ),
              ),
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
