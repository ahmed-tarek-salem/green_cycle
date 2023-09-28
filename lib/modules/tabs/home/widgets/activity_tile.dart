import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 75.h,
      padding: EdgeInsets.all(10.sp),
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
              Text('استخدمت صندوق إعادة التدوير'),
              Text(
                '2023/9/20',
                style: TextStyle(fontSize: 10.sp),
              )
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'حصلت على 20 نقطة',
              style: TextStyle(fontSize: 10.sp),
            ),
          )
        ],
      ),
    );
  }
}
