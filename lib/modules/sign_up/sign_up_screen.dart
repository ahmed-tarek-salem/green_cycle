import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/theme/app_images.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50.h),
            Center(
                child: Image.asset(
              AppImages.logoPng,
            )),
            SizedBox(height: 12.h),
            TextFormField(),
          ],
        ),
      ),
    );
  }
}
