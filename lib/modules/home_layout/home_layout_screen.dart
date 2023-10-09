import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/home_layout/home_layout_controller.dart';
import 'package:green_cycle/modules/home_layout/widgets/app_drawer.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/shared_widgets/custom_error_widget.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/theme/app_icons.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';

class HomeLayoutScreen extends GetView<HomeLayoutController> {
  const HomeLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (context) {
          return Scaffold(
            drawer: AppDrawer(controller: controller),
            resizeToAvoidBottomInset: false,
            appBar:
                returnHomeAppBar(controller.titles[controller.getNavBarIndex]),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.toNamed(AppRoutes.actionScreen);
              },
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.add,
                size: 30.sp,
              ),
            ),
            body: GetBuilder(
                init: controller,
                builder: (_) {
                  if (controller.isLoading) {
                    return const CustomProgressIndicator();
                  } else if (controller.isError) {
                    return CustomErrorWidget(onRefresh: controller.getUser);
                  }
                  return controller.tabs[controller.getNavBarIndex];
                }),
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
