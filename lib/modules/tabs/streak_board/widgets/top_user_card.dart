import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class TopUserCard extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final bool isFirst;

  const TopUserCard({
    required this.rank,
    required this.name,
    required this.points,
    this.isFirst = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: isFirst ? AppColors.primary : AppColors.secondary,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: isFirst
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isFirst ? 40.w : 32.w,
            height: isFirst ? 40.w : 32.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFirst ? AppColors.secondary : AppColors.primary,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: isFirst ? 20.sp : 16.sp,
                  fontWeight: FontWeight.w800,
                  color: isFirst ? AppColors.primary : AppColors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isFirst ? AppColors.white : AppColors.primary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '$points نقطة',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: isFirst ? AppColors.kLightSecondary : AppColors.grey5B,
            ),
          ),
        ],
      ),
    );
  }
}
