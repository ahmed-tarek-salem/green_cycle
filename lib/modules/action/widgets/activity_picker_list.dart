import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';
import 'package:green_cycle/modules/rewards/widgets/reward_action_card.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

/// First step of a submission: the student picks what they did.
class ActivityPickerList extends StatelessWidget {
  final List<RewardAction> actions;
  final ValueChanged<RewardAction> onSelected;

  /// Activities with a request still under review. They are shown but can't
  /// be picked, since the server refuses a second request for them.
  final Set<String> pendingSlugs;

  const ActivityPickerList({
    required this.actions,
    required this.onSelected,
    this.pendingSlugs = const {},
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return Center(
        child: Text(
          'لا توجد أنشطة متاحة حالياً',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: AppConstants.topPadding,
      ),
      itemCount: actions.length + 1,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (_, index) {
        if (index == 0) {
          return Text(
            'اختر النشاط الذي قمت به',
            style: Get.textTheme.headlineMedium,
          );
        }
        final action = actions[index - 1];
        if (pendingSlugs.contains(action.slug)) {
          return RewardActionCard(
            action: action,
            statusText: 'طلبك قيد المراجعة',
          );
        }
        return RewardActionCard(
          action: action,
          onTap: () => onSelected(action),
        );
      },
    );
  }
}
