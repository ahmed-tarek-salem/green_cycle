import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 280.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius:
              BorderRadiusDirectional.circular(AppConstants.borderRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      'اسم الفاعلية',
                      style: Get.textTheme.titleLarge,
                    ),
                    Spacer(),
                    Text('نبذة عن الفاعلية نتحدث فيها عن أهميتها وأهدافها'),
                    SizedBox(height: 60.h),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      '24',
                      style: TextStyle(
                          fontSize: 64.sp, fontWeight: FontWeight.w400),
                    ),
                    Text('أغسطس'),
                    SizedBox(height: 4.h),
                    Text(
                      'المبني القديم الدور الأول أو الثاني',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    Text('أغسطس'),
                  ],
                )),
          ],
        ));
  }
}
