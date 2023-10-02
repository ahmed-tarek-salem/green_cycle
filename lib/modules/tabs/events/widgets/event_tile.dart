import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/main.dart';
import 'package:green_cycle/models/response_models/event_response_model.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:intl/intl.dart';

class EventTile extends StatelessWidget {
  final Event event;
  const EventTile({
    required this.event,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String dayNumber = DateFormat('dd').format(event.date!);
    String monthName = DateFormat.MMMM('ar').format(event.date!);
    String time = DateFormat('hh:mm a', 'ar').format(event.date!);

    return Container(
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
                    Text(
                      event.name ?? '-',
                      style: Get.textTheme.titleLarge,
                    ),
                    SizedBox(height: 20.h),
                    Text(event.description ?? '-'),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      dayNumber,
                      style: TextStyle(
                          fontSize: 64.sp, fontWeight: FontWeight.w400),
                    ),
                    Text(monthName),
                    SizedBox(height: 4.h),
                    Text(
                      event.details ?? '-',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    Text(time),
                  ],
                )),
          ],
        ));
  }
}
