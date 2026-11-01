import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/models/response_models/my_rewards_response_model.dart';
import 'package:green_cycle/modules/rewards/rewards_texts.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class RewardLevelTile extends StatelessWidget {
  final RewardLevel level;
  final bool isCurrent;

  const RewardLevelTile({
    required this.level,
    required this.isCurrent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final detailStyle = TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.grey5B,
      height: 1.5,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.kLightSecondary : AppColors.secondary,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border:
            isCurrent ? Border.all(color: AppColors.primary, width: 1.5) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (level.emoji.isNotEmpty) ...[
            Text(level.emoji, style: TextStyle(fontSize: 28.sp)),
            SizedBox(width: 10.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level.titleAr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(levelRangeText(level), style: detailStyle),
                if (level.rewardAr.isNotEmpty)
                  Text('الجائزة: ${level.rewardAr}', style: detailStyle),
              ],
            ),
          ),
          if (isCurrent) ...[
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'مستواك',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
