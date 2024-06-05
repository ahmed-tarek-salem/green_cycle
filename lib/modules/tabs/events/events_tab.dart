import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/tabs/events/events_controller.dart';
import 'package:green_cycle/modules/tabs/events/widgets/event_tile.dart';
import 'package:green_cycle/shared_widgets/custom_error_widget.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/theme/app_images.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class EventsTab extends GetView<EventsController> {
  const EventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
            vertical: AppConstants.topPadding),
        child: GetBuilder(
            init: controller,
            builder: (_) {
              if (controller.isLoading) {
                return const CustomProgressIndicator();
              } else if (controller.isError) {
                return CustomErrorWidget(onRefresh: () {
                  controller.getEvents();
                });
              } else if (controller.events.isEmpty) {
                return Column(
                  children: [
                    Image.asset(AppImages.event),
                    SizedBox(height: 20.h),
                    Text('لا توجد فعاليات قادمة',
                        style: Get.textTheme.displayMedium),
                    SizedBox(height: 5.h),
                    Text('إذا تمت إضافة أي فعالية جديدة سوف تظهر هنا'),
                  ],
                );
              }
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(height: 20.h),
                itemBuilder: (context, index) {
                  return EventTile(
                    event: controller.events[index],
                  );
                },
                itemCount: controller.events.length,
              );
            }));
  }
}
