import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/leaderboard_response_model.dart';
import 'package:green_cycle/modules/home_layout/home_layout_controller.dart';
import 'package:green_cycle/modules/tabs/streak_board/streak_board_controller.dart';
import 'package:green_cycle/modules/tabs/streak_board/widgets/current_user_section.dart';
import 'package:green_cycle/modules/tabs/streak_board/widgets/top_user_card.dart';
import 'package:green_cycle/shared_widgets/custom_error_widget.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class StreakBoardTab extends GetView<StreakBoardController> {
  const StreakBoardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StreakBoardController>(
      init: controller,
      builder: (_) {
        if (controller.isLoading) {
          return const CustomProgressIndicator();
        }
        if (controller.isError) {
          return CustomErrorWidget(onRefresh: controller.loadLeaderboard);
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.loadLeaderboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
              vertical: AppConstants.topPadding,
            ),
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 20.h),
                _buildPodium(controller.topUsers),
                SizedBox(height: 24.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'ترتيبك الحالي',
                    style: Get.textTheme.headlineMedium,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildCurrentUser(),
                SizedBox(height: 20.h),
                _buildTipsCard(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
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
            style:
                Get.textTheme.headlineSmall!.copyWith(color: Colors.white),
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
    );
  }

  Widget _buildPodium(List<LeaderboardEntry> entries) {
    if (entries.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Text(
          'لا يوجد متصدرون بعد',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      );
    }

    final first = entries.elementAtOrNull(0);
    final second = entries.elementAtOrNull(1);
    final third = entries.elementAtOrNull(2);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: _slot(second)),
        SizedBox(width: 8.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _slot(first, isFirst: true),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(child: _slot(third)),
      ],
    );
  }

  Widget _slot(LeaderboardEntry? entry, {bool isFirst = false}) {
    if (entry == null) return const SizedBox();
    return TopUserCard(
      rank: entry.rank,
      name: entry.name ?? '',
      points: entry.totalPoints,
      isFirst: isFirst,
    );
  }

  Widget _buildCurrentUser() {
    final rank = controller.currentUserRank.value;
    if (rank == null) return const SizedBox();
    final homeController = Get.find<HomeLayoutController>();
    return CurrentUserSection(
      rank: rank.rank,
      name: homeController.user.name ?? 'أنت',
      points: rank.totalPoints,
      tiedWith: rank.tiedWith,
    );
  }

  Widget _buildTipsCard() {
    return Container(
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
