import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/models/response_models/user_response_model.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:intl/intl.dart';

class ActivityTile extends StatelessWidget {
  final Activity activity;
  const ActivityTile({
    required this.activity,
    super.key,
  });
  String formatCreatedAt(DateTime createdAt) {
    final DateFormat formatter = DateFormat('yyyy/MM/dd');

    String formattedDate = formatter.format(createdAt);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(activity.summary),
              ),
              Text(
                formatCreatedAt(activity.createdAt),
                style: TextStyle(fontSize: 10.sp),
              )
            ],
          ),
          SizedBox(height: 30.h),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              activity.details,
              style: TextStyle(fontSize: 10.sp),
            ),
          )
        ],
      ),
    );
  }
}
