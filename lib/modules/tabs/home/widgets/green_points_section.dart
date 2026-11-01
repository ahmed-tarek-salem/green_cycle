import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/home_layout/home_layout_controller.dart';
import 'package:green_cycle/modules/rewards/widgets/rewards_catalog_view.dart';
import 'package:green_cycle/modules/tabs/home/widgets/level_progress.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';

class GreenPointsSection extends GetView<HomeLayoutController> {
  const GreenPointsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: 20.h,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 120.w,
                child: Text(
                  'عدد النقاط الخضراء:',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SizedBox(width: 30.w),
              GetBuilder(
                init: controller,
                builder: (_) {
                  // The rewards total is reloaded after a review or a trip
                  // confirmation, while the user is loaded once.
                  final points = controller.rewards.value?.totalPoints ??
                      controller.user.totalPoints ??
                      0;
                  return Text(
                    points.toString(),
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ],
          ),
          GetBuilder(
            init: controller,
            builder: (_) {
              final rewards = controller.rewards.value;
              if (rewards?.level == null) return const SizedBox();
              return Padding(
                padding: EdgeInsets.only(top: 14.h),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.toNamed(
                    AppRoutes.rewardsScreen,
                    arguments: RewardsCatalogView.levelsTab,
                  ),
                  child: LevelProgress(rewards: rewards!),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
