import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';
import 'package:green_cycle/modules/rewards/rewards_texts.dart';
import 'package:green_cycle/modules/rewards/widgets/reward_action_card.dart';
import 'package:green_cycle/modules/rewards/widgets/reward_level_tile.dart';
import 'package:green_cycle/modules/rewards/widgets/reward_prize_tile.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

/// The rewards catalog in three tabs: activities, levels and prizes.
///
/// Takes plain data so it can be rendered without a controller.
class RewardsCatalogView extends StatelessWidget {
  static const activitiesTab = 0;
  static const levelsTab = 1;
  static const prizesTab = 2;

  final RewardsCatalogResponseModel catalog;

  /// The student's balance, used to mark their current level.
  final int totalPoints;
  final int initialTab;
  final Future<void> Function()? onRefresh;

  const RewardsCatalogView({
    required this.catalog,
    required this.totalPoints,
    this.initialTab = activitiesTab,
    this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: initialTab.clamp(activitiesTab, prizesTab),
      child: Column(
        children: [
          TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.grey5B,
            indicatorColor: AppColors.primary,
            labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            tabs: const [
              Tab(text: 'الأنشطة'),
              Tab(text: 'المستويات'),
              Tab(text: 'الجوائز'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [_buildActivities(), _buildLevels(), _buildPrizes()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivities() {
    final bonuses = bonusLines(catalog.config);
    return _list(
      emptyText: 'لا توجد أنشطة متاحة حالياً',
      children: [
        if (catalog.actions.isNotEmpty)
          const _Intro('كل نشاط تتم مراجعته من الإدارة قبل إضافة نقاطه.'),
        for (final action in catalog.actions) RewardActionCard(action: action),
        if (bonuses.isNotEmpty) _BonusCard(lines: bonuses),
      ],
    );
  }

  Widget _buildLevels() {
    final current = currentLevelIndex(catalog.levels, totalPoints);
    return _list(
      emptyText: 'لا توجد مستويات متاحة حالياً',
      children: [
        for (var i = 0; i < catalog.levels.length; i++)
          RewardLevelTile(level: catalog.levels[i], isCurrent: i == current),
      ],
    );
  }

  Widget _buildPrizes() {
    return _list(
      emptyText: 'لا توجد جوائز متاحة حالياً',
      children: [
        for (final prize in catalog.prizes) RewardPrizeTile(prize: prize),
      ],
    );
  }

  Widget _list({required List<Widget> children, required String emptyText}) {
    final list = ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: AppConstants.topPadding,
      ),
      itemCount: children.isEmpty ? 1 : children.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (_, index) =>
          children.isEmpty ? _Empty(emptyText) : children[index],
    );
    final refresh = onRefresh;
    if (refresh == null) return list;
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: refresh,
      child: list,
    );
  }
}

class _Intro extends StatelessWidget {
  final String text;

  const _Intro(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.grey5B,
        height: 1.5,
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final String text;

  const _Empty(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.h),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// Bonuses the server adds on its own, with nothing to submit.
class _BonusCard extends StatelessWidget {
  final List<String> lines;

  const _BonusCard({required this.lines});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.kLightSecondary,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مكافآت تلقائية',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'تضاف إلى رصيدك دون أن ترفع شيئاً',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.grey5B,
            ),
          ),
          for (final line in lines) ...[
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primary,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    line,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
