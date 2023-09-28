import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/tabs/locations/locations_controller.dart';
import 'package:green_cycle/modules/tabs/locations/widgets/location_tile.dart';
import 'package:green_cycle/modules/tabs/locations/widgets/select_door_dialog.dart';
import 'package:green_cycle/shared_widgets/custom_cached_network_image.dart';
import 'package:green_cycle/shared_widgets/custom_error_widget.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
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
      child: GetBuilder(
          init: controller,
          builder: (_) {
            if (controller.isLoading) {
              return const CustomProgressIndicator();
            } else if (controller.isError) {
              return CustomErrorWidget(onRefresh: controller.getLocations);
            }
            return Column(
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
                              onTap: () {
                                controller.selectedLocationIndex = 0;
                                // showDialog(
                                //   context: context,
                                //   barrierDismissible: true,
                                //   builder: (BuildContext context) {
                                //     return selectDoorDialog(controller: controller);
                                //   },
                                // );
                              },
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
                                    return selectDoorDialog(
                                        controller: controller);
                                  },
                                );
                              },
                              name: 'المبني الجديد',
                              index: 1,
                              isActive: controller.selectedLocationIndex == 1),
                          SizedBox(width: 10.w),
                          LocationTile(
                              onTap: () {
                                controller.selectedLocationIndex = 2;
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return selectDoorDialog(
                                        controller: controller);
                                  },
                                );
                              },
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
                        decoration: BoxDecoration(
                            color: AppColors.greyVeryLighF5,
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadius)),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return InteractiveViewer(
                                maxScale: 5,
                                child: CustomCachedNetworkImage(
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                    imageUrl: controller.getSelectedMap()),
                              );
                            }));
                          },
                          child: CustomCachedNetworkImage(
                              height: 200.h,
                              width: double.infinity,
                              imageUrl: controller.getSelectedMap()),
                        ),
                      );
                    }),
                SizedBox(height: 10.h),
                const Center(
                  child: Text(
                    'اتجه لأقرب صندوق إعادة تدوير لك',
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            );
          }),
    );
  }
}
