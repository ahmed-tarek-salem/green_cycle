import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/home_layout/home_layout_controller.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class GreenPointsSection extends GetView<HomeLayoutController> {
  const GreenPointsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding, vertical: 20.h),
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
      child: Row(
        children: [
          SizedBox(
            width: 120.w,
            child: Text('عدد النقاط الخضراء:',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w300)),
          ),
          SizedBox(width: 30.w),
          GetBuilder(
              init: controller,
              builder: (_) {
                return Text(controller.user.totalPoints.toString(),
                    style: TextStyle(
                        fontSize: 40.sp, fontWeight: FontWeight.w600));
              })
        ],
      ),
    );
  }
}
