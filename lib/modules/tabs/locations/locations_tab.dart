import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/tabs/locations/locations_controller.dart';
import 'package:green_cycle/modules/tabs/locations/widgets/location_tile.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class LocationsTab extends GetView<LocationsController> {
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
          GetBuilder(
              init: controller,
              builder: (_) {
                return Row(
                  children: [
                    LocationTile(
                        name: 'ساحة الكلية',
                        index: 0,
                        isActive: controller.selectedLocationIndex == 0),
                    SizedBox(width: 10.w),
                    LocationTile(
                        onTap: () {
                          controller.selectedLocationIndex = 1;
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return GetBuilder(
                                  init: controller,
                                  builder: (_) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'اختر الطابق',
                                                style: Get
                                                    .textTheme.headlineMedium,
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: AppColors.primary,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 28.sp),
                                          Row(
                                            children: [
                                              DoorTab(
                                                doorName: 'الطابق الأول',
                                                index: 1,
                                                isActive: controller
                                                        .selectedDoorIndex ==
                                                    1,
                                                onTap: () {},
                                              ),
                                              SizedBox(width: 10.w),
                                              DoorTab(
                                                doorName: 'الطابق الثاني',
                                                index: 1,
                                                isActive: controller
                                                        .selectedDoorIndex ==
                                                    1,
                                                onTap: () {},
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          Row(
                                            children: [
                                              DoorTab(
                                                doorName: 'الطابق الثالث',
                                                index: 2,
                                                isActive: controller
                                                        .selectedDoorIndex ==
                                                    2,
                                                onTap: () {
                                                  controller.selectedDoorIndex =
                                                      2;
                                                },
                                              ),
                                              SizedBox(width: 10.w),
                                              DoorTab(
                                                doorName: 'الطابق الرابع',
                                                index: 3,
                                                isActive: controller
                                                        .selectedDoorIndex ==
                                                    3,
                                                onTap: () {},
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          Row(
                                            children: [
                                              DoorTab(
                                                doorName: 'الطابق الخامس',
                                                index: 4,
                                                isActive: controller
                                                        .selectedDoorIndex ==
                                                    4,
                                                onTap: () {},
                                              ),
                                              SizedBox(width: 10.w),
                                              DoorTab(
                                                doorName: 'الطابق السادس',
                                                index: 5,
                                                isActive: controller
                                                        .selectedDoorIndex ==
                                                    5,
                                                onTap: () {},
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 30.h),
                                          PrimaryButton(
                                              onTap: () {
                                                Get.back();
                                              },
                                              text: 'تأكيد')
                                        ],
                                      ),
                                    );
                                  });
                            },
                          );
                        },
                        name: 'المبني الجديد',
                        index: 1,
                        isActive: controller.selectedLocationIndex == 1),
                    SizedBox(width: 10.w),
                    LocationTile(
                        name: 'المبني القديم',
                        index: 2,
                        isActive: controller.selectedLocationIndex == 2),
                  ],
                );
              }),
          SizedBox(height: 20.h),
          GetBuilder(
              init: controller,
              builder: (_) {
                return Container(
                  width: double.infinity,
                  height: 200.h,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Image.asset(
                          controller.loactionImagePaths[
                              controller.selectedLocationIndex],
                        );
                      }));
                    },
                    child: Image.asset(
                      controller
                          .loactionImagePaths[controller.selectedLocationIndex],
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.greyVeryLighF5,
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadius)),
                );
              }),
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

class DoorTab extends StatelessWidget {
  final String doorName;
  final int index;
  final VoidCallback onTap;
  final bool isActive;
  const DoorTab({
    required this.doorName,
    required this.index,
    required this.onTap,
    required this.isActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              border: Border.all(color: AppColors.primary),
              color: isActive ? AppColors.primary : Colors.white),
          child: Center(
            child: Text(
              doorName,
              style:
                  TextStyle(color: isActive ? Colors.white : AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }
}
