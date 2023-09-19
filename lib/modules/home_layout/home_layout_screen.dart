import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/home_layout/home_layout_controller.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/theme/app_icons.dart';

class HomeLayoutScreen extends GetView<HomeLayoutController> {
  const HomeLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              centerTitle: true,
              title: Text(
                'Green Cycle',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.add,
                size: 30.sp,
              ),
            ),
            body: controller.tabs[controller.getNavBarIndex],
            bottomNavigationBar: CurvedNavigationBar(
              items: [
                SvgPicture.asset(AppIcons.home),
                SvgPicture.asset(AppIcons.location),
                SvgPicture.asset(AppIcons.calendar),
                SvgPicture.asset(AppIcons.pin),
              ],
              onTap: (val) {
                controller.navBarIndex = val;
              },
              color: AppColors.primary,
              backgroundColor: Colors.transparent,
            ),
          );
        });
  }
}
