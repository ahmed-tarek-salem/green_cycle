import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/carpool/carpool_controller.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/shared_widgets/custom_error_widget.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';

class CarpoolHomeScreen extends GetView<CarpoolController> {
  const CarpoolHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnHomeAppBar('مشاركة السيارة'),
      body: GetBuilder<CarpoolController>(
        init: controller,
        builder: (_) {
          if (controller.isLoading) return const CustomProgressIndicator();
          if (controller.isError) {
            return CustomErrorWidget(onRefresh: controller.load);
          }
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
              vertical: AppConstants.topPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _actionCard(
                  title: 'أنا سائق',
                  subtitle: controller.hasActiveOffer
                      ? 'إدارة رحلتك الحالية'
                      : 'أنشئ رحلتك وشارك مقاعدك',
                  icon: Icons.directions_car,
                  onTap: () => Get.toNamed(
                    controller.hasActiveOffer
                        ? AppRoutes.carpoolMyOfferScreen
                        : AppRoutes.carpoolDriverSetupScreen,
                  ),
                ),
                SizedBox(height: 16.h),
                _actionCard(
                  title: 'أبحث عن مشوار',
                  subtitle: 'ابحث عن سائق يمر بمنطقتك',
                  icon: Icons.search,
                  onTap: () => Get.toNamed(AppRoutes.carpoolSearchScreen),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _actionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      child: Container(
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26.sp,
              backgroundColor: AppColors.primary,
              child: Icon(icon, color: AppColors.white, size: 26.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Get.textTheme.headlineSmall),
                  SizedBox(height: 4.h),
                  Text(subtitle,
                      style:
                          TextStyle(fontSize: 12.sp, color: AppColors.primary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
