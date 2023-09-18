import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:green_cycle/theme/app_colors.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  const CustomProgressIndicator({Key? key, this.size, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitSpinningLines(
        color: color ?? AppColors.primary,
        duration: const Duration(seconds: 2),
        size: size ?? 50.sp,
      ),
      //  CircularProgressIndicator(
      //   color: Theme.of(context).primaryColor,
      // ),
    );
  }
}
