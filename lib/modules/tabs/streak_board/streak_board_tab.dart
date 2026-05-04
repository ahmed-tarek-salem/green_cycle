import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/tabs/streak_board/widgets/current_user_section.dart';
import 'package:green_cycle/modules/tabs/streak_board/widgets/top_user_card.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class StreakBoardTab extends StatelessWidget {
  const StreakBoardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: AppConstants.topPadding,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Column(
              children: [
                Text(
                  'لوحة المتصدرين',
                  style: Get.textTheme.headlineSmall!
                      .copyWith(color: Colors.white),
                ),
                SizedBox(height: 4.h),
                Text(
                  'أفضل 3 طلاب بكلية الصيدلة، جامعة الإسكندرية',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.kLightSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: const TopUserCard(
                  rank: 2,
                  name: 'سارة أحمد',
                  points: 1850,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: const TopUserCard(
                    rank: 1,
                    name: 'محمد علي',
                    points: 2340,
                    isFirst: true,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: const TopUserCard(
                  rank: 3,
                  name: 'فاطمة حسن',
                  points: 1620,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'ترتيبك الحالي',
              style: Get.textTheme.headlineMedium,
            ),
          ),
          SizedBox(height: 10.h),
          const CurrentUserSection(
            rank: 22,
            name: 'أنت',
            points: 450,
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Column(
              children: [
                Text(
                  'كيف تزيد نقاطك؟',
                  style: Get.textTheme.headlineMedium,
                ),
                SizedBox(height: 10.h),
                _buildTipRow('قم بتسليم المواد القابلة لإعادة التدوير في صناديق الكلية'),
                SizedBox(height: 8.h),
                _buildTipRow('شارك في الفعاليات البيئية داخل حرم الكلية'),
                SizedBox(height: 8.h),
                _buildTipRow('أكمل الاستبيانات المتاحة'),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildTipRow(String text) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          color: AppColors.primary,
          size: 18.sp,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
