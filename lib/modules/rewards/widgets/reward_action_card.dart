import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';
import 'package:green_cycle/modules/rewards/rewards_texts.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

/// One way to earn points: what it is, what it is worth, and how to prove it.
class RewardActionCard extends StatelessWidget {
  final RewardAction action;

  /// When set, the card is a choice: it shows a chevron and reacts to taps.
  final VoidCallback? onTap;

  /// A short note about the student's own state, like a request under
  /// review. The card is dimmed while it shows.
  final String? statusText;

  const RewardActionCard({
    required this.action,
    this.onTap,
    this.statusText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cooldown = cooldownText(action.cooldownDays);
    final detailStyle = TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.grey5B,
      height: 1.5,
    );

    final card = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (action.icon.isNotEmpty) ...[
            Text(action.icon, style: TextStyle(fontSize: 24.sp)),
            SizedBox(width: 10.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.nameAr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: [
                    for (final text in actionPointsTexts(action))
                      _PointsPill(text: text),
                  ],
                ),
                if (action.descriptionAr.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(action.descriptionAr, style: detailStyle),
                ],
                if (action.verificationAr.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Text(
                    'طريقة الإثبات: ${action.verificationAr}',
                    style: detailStyle,
                  ),
                ],
                if (cooldown != null) ...[
                  SizedBox(height: 2.h),
                  Text(cooldown, style: detailStyle),
                ],
                if (statusText != null) ...[
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.hourglass_top,
                        color: AppColors.primary,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        statusText!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null) ...[
            SizedBox(width: 6.w),
            Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 14.sp),
          ],
        ],
      ),
    );

    if (statusText != null) return Opacity(opacity: 0.6, child: card);
    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      child: card,
    );
  }
}

class _PointsPill extends StatelessWidget {
  final String text;

  const _PointsPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }
}
