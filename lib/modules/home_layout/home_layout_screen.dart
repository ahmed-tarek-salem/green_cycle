import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:green_cycle/main.dart';
import 'package:green_cycle/modules/home_layout/tabs/home_tab.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/theme/app_icons.dart';

class HomeLayoutScreen extends GetView {
  const HomeLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(
          'Green Cycle',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.add,
          size: 30.sp,
        ),
      ),
      body: HomeTab(),
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          SvgPicture.asset(AppIcons.home),
          SvgPicture.asset(AppIcons.calendar),
          SvgPicture.asset(AppIcons.pin),
          SvgPicture.asset(AppIcons.location),
        ],
        color: AppColors.primary,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
