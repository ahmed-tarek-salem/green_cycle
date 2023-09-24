import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/theme/app_images.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';

class SuccessProcessScreen extends StatelessWidget {
  const SuccessProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'تم تسجيل البيانات بنجاح',
              style: Get.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.sp),
            const Text('سيتم قبولك خلال ٢٤ ساعة، يمكنك بعدها تسجيل الدخول',
                textAlign: TextAlign.center),
            SizedBox(height: 20.sp),
            Image.asset(AppImages.success),
            SizedBox(height: 50.sp),
            PrimaryButton(
                onTap: () {
                  Get.offAllNamed(AppRoutes.loginScreen);
                },
                text: 'العودة')
          ],
        ),
      ),
    );
  }
}
