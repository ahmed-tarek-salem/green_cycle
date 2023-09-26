import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/tabs/locations/locations_controller.dart';
import 'package:green_cycle/modules/tabs/locations/locations_tab.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/theme/app_colors.dart';

class selectDoorDialog extends StatelessWidget {
  const selectDoorDialog({
    super.key,
    required this.controller,
  });

  final LocationsController controller;

  static const List<String> doors = [
    "الطابق الأول",
    "الطابق  الثاني",
    "الطابق الثالث",
  ];
  fun() {
    List.generate(
        doors.length,
        (index) => DoorTab(
            doorName: doors[index],
            index: index,
            onTap: () {
              controller.selectedDoorIndex = index;
            },
            isActive: controller.selectedDoorIndex == index));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'اختر الطابق',
                      style: Get.textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primary,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 28.sp),
                Wrap(
                  children: List.generate(
                      doors.length,
                      (index) => DoorTab(
                          doorName: doors[index],
                          index: index,
                          onTap: () {
                            controller.selectedDoorIndex = index;
                          },
                          isActive: controller.selectedDoorIndex == index)),
                ),
                // Row(
                //   children: [
                //     DoorTab(
                //       doorName: 'الطابق الأول',
                //       index: 0,
                //       isActive: controller.selectedDoorIndex == 0,
                //       onTap: () {
                //         controller.selectedDoorIndex = 0;
                //       },
                //     ),
                //     SizedBox(width: 10.w),
                //     DoorTab(
                //       doorName: 'الطابق الثاني',
                //       index: 1,
                //       isActive: controller.selectedDoorIndex == 1,
                //       onTap: () {
                //         controller.selectedDoorIndex = 1;
                //       },
                //     ),
                //   ],
                // ),
                // SizedBox(height: 10.h),
                // Row(
                //   children: [
                //     DoorTab(
                //       doorName: 'الطابق الثالث',
                //       index: 2,
                //       isActive: controller.selectedDoorIndex == 2,
                //       onTap: () {
                //         controller.selectedDoorIndex = 2;
                //       },
                //     ),
                //     SizedBox(width: 10.w),
                //     DoorTab(
                //       doorName: 'الطابق الرابع',
                //       index: 3,
                //       isActive: controller.selectedDoorIndex == 3,
                //       onTap: () {
                //         controller.selectedDoorIndex = 4;
                //       },
                //     ),
                //   ],
                // ),
                // SizedBox(height: 10.h),
                // Row(
                //   children: [
                //     DoorTab(
                //       doorName: 'الطابق الخامس',
                //       index: 4,
                //       isActive: controller.selectedDoorIndex == 4,
                //       onTap: () {},
                //     ),
                //     SizedBox(width: 10.w),
                //     DoorTab(
                //       doorName: 'الطابق السادس',
                //       index: 5,
                //       isActive: controller.selectedDoorIndex == 5,
                //       onTap: () {},
                //     ),
                //   ],
                // ),
                // SizedBox(height: 10.h),
                // DoorTab(
                //   doorName: 'الطابق السابع',
                //   index: 6,
                //   isActive: controller.selectedDoorIndex == 6,
                //   onTap: () {},
                // ),
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
  }
}
