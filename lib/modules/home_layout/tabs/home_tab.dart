import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding, vertical: 20.h),
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
            child: Row(
              children: [
                SizedBox(
                  width: 120.w,
                  child: Text('عدد النقاط الخضراء:',
                      style: TextStyle(
                          fontSize: 24.sp, fontWeight: FontWeight.w300)),
                ),
                SizedBox(width: 30.w),
                Text('35',
                    style:
                        TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w600))
              ],
            ),
          ),
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
                      return Container(
                        width: double.infinity,
                        height: 75.h,
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConstants.borderRadius),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('استخدمت صندوق إعادة التدوير'),
                                Text(
                                  '2023/9/20',
                                  style: TextStyle(fontSize: 10.sp),
                                )
                              ],
                            ),
                            Spacer(),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'حصلت على 20 نقطة',
                                style: TextStyle(fontSize: 10.sp),
                              ),
                            )
                          ],
                        ),
                      );
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
