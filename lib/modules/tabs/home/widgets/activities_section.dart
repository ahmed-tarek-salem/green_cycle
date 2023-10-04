import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/home_layout/home_layout_controller.dart';
import 'package:green_cycle/modules/tabs/home/widgets/activity_tile.dart';

class ActivitiesSection extends GetView<HomeLayoutController> {
  const ActivitiesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
        separatorBuilder: (context, index) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          return ActivityTile(
            activity: controller.user.activities![index],
          );
        },
        itemCount: controller.user.activities?.length ?? 0,
      ),
    );
  }
}
