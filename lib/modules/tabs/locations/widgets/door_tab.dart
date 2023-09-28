import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/theme/app_colors.dart';

class DoorTab extends StatelessWidget {
  final String doorName;
  final int index;
  final VoidCallback onTap;
  final bool isActive;
  const DoorTab({
    required this.doorName,
    required this.index,
    required this.onTap,
    required this.isActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              border: Border.all(color: AppColors.primary),
              color: isActive ? AppColors.primary : Colors.white),
          child: Center(
            child: Text(
              doorName,
              style:
                  TextStyle(color: isActive ? Colors.white : AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }
}
