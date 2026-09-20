import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/models/response_models/my_rewards_response_model.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/points_label.dart';

/// Current level title, a bar towards the next level, and the reward the
/// student is working towards.
class LevelProgress extends StatelessWidget {
  final MyRewardsResponseModel rewards;

  const LevelProgress({required this.rewards, super.key});

  @override
  Widget build(BuildContext context) {
    final level = rewards.level;
    if (level == null) return const SizedBox();
    final next = rewards.nextLevel;

    final statusText = next == null
        ? 'وصلت لأعلى مستوى!'
        : 'باقي ${pointsLabel(rewards.pointsToNextLevel)} للوصول إلى ${next.titleAr} ${next.emoji}';
    final rewardText = next == null
        ? (level.rewardAr.isEmpty ? null : 'جائزتك: ${level.rewardAr}')
        : (next.rewardAr.isEmpty
            ? null
            : 'جائزة المستوى القادم: ${next.rewardAr}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مستواك: ${level.titleAr} ${level.emoji}',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: rewards.levelProgress,
            minHeight: 8.h,
            backgroundColor: AppColors.white,
            color: AppColors.primary,
            semanticsLabel: 'التقدم نحو المستوى التالي',
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          statusText,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        if (rewardText != null) ...[
          SizedBox(height: 2.h),
          Text(
            rewardText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.grey5B,
            ),
          ),
        ],
      ],
    );
  }
}
