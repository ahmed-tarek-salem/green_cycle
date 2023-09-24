import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/theme/app_images.dart';

mixin OverlyaysMixin on GetxController {
  void hideLoadingOverlay() {
    SmartDialog.dismiss();
  }

  void showLoadingOverlay() {
    SmartDialog.showLoading(builder: (_) {
      return CustomProgressIndicator(
        size: 100.sp,
      );
    });
  }

  Future showAnimatedDialog(BuildContext context, Widget alertDialog) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(opacity: a1.value, child: alertDialog),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        });
  }

  Future showErrorDialog(String message) async {
    final context = Get.context!;
    return showAnimatedDialog(
        context,
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppImages.error),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 20.sp,
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(
                        horizontal: 30.sp, vertical: 12.sp),
                  ),
                  child: Text(
                    'ok'.tr,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
