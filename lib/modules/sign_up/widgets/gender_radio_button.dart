import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/theme/app_colors.dart';

class GenderRadioButton extends StatelessWidget {
  final String title;
  final int index;
  final bool isActive;
  const GenderRadioButton({
    required this.title,
    required this.index,
    required this.isActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        SizedBox(width: 10.w),
        CircleAvatar(
          backgroundColor: AppColors.primary,
          radius: 10.sp,
          child: CircleAvatar(
              backgroundColor: AppColors.white,
              radius: 9.sp,
              child: CircleAvatar(
                backgroundColor: isActive ? AppColors.primary : Colors.white,
                radius: 8.sp,
              )),
        ),
      ],
    );
  }
}
