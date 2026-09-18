import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/home_layout/home_layout_controller.dart';
import 'package:green_cycle/modules/tabs/home/widgets/activity_tile.dart';
import 'package:green_cycle/theme/app_colors.dart';

class ActivitiesSection extends GetView<HomeLayoutController> {
  const ActivitiesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final activities = controller.user.activities;
    if (activities == null || activities.isEmpty) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'لا توجد إسهامات بعد',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'شارك في الأنشطة البيئية لتظهر إسهاماتك هنا',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
        separatorBuilder: (context, index) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          return ActivityTile(activity: activities[index]);
        },
        itemCount: activities.length,
      ),
    );
  }
}
