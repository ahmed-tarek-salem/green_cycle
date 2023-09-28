import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/home_layout/home_layout_controller.dart';
import 'package:green_cycle/modules/home_layout/widgets/drawer_tile.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/theme/app_images.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';

class AppDrawer extends StatelessWidget {
  final HomeLayoutController controller;
  const AppDrawer({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: 10.h, horizontal: AppConstants.horizontalPadding),
            height: 80.h,
            width: double.infinity,
            color: AppColors.primary,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('القائمة',
                      style: TextStyle(color: Colors.white, fontSize: 24.sp)),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: AppConstants.topPadding, horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(AppImages.user),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'اسم المستخدم',
                              style: Get.textTheme.headlineMedium,
                            ),
                            SizedBox(height: 10.h),
                            Text('الرقم التعريفي')
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30.h),
                  DrawerTile(
                    onTap: () {
                      Get.toNamed(AppRoutes.aboutUsScreen);
                    },
                    title: 'من نحن',
                  ),
                  DrawerTile(
                    onTap: () {
                      Get.toNamed(AppRoutes.faqScreen);
                    },
                    title: 'الأسئلة الأكثر شيوعاً',
                  ),
                  DrawerTile(
                    onTap: () {},
                    title: 'استبدل نقاطك الخضراء',
                  ),
                  const Spacer(),
                  DrawerTile(
                    onTap: controller.logout,
                    backgroundColor: Colors.transparent,
                    title: 'تسجيل الخروج',
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
