import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/tabs/locations/widgets/location_tile.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class LocationsTab extends StatelessWidget {
  const LocationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: 25.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر المكان الأقرب لك',
            style: Get.textTheme.headlineSmall,
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              const LocationTile(name: 'ساحة الكلية', index: 0),
              SizedBox(width: 10.w),
              const LocationTile(name: 'المبني الجديد', index: 1),
              SizedBox(width: 10.w),
              const LocationTile(name: 'المبني القديم', index: 2),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
                color: AppColors.greyVeryLighF5,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
          ),
          SizedBox(height: 10.h),
          Center(
            child: Text(
              'اتجه لأقرب صندوق إعادة تدوير لك',
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
