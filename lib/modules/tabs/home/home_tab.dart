import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/tabs/home/widgets/activity_tile.dart';
import 'package:green_cycle/modules/tabs/home/widgets/green_points_section.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
      child: Column(
        children: [
          SizedBox(height: AppConstants.topPadding),
          const GreenPointsSection(),
          SizedBox(height: 15.h),
          Container(
            width: double.infinity,
            height: 260.h,
            decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 15.h,
                      horizontal: AppConstants.horizontalPadding),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppConstants.borderRadius),
                          topRight:
                              Radius.circular(AppConstants.borderRadius))),
                  child: Text(
                    'آخر إسهاماتك',
                    style: Get.textTheme.headlineSmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      return ActivityTile();
                    },
                    itemCount: 2,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }
}
