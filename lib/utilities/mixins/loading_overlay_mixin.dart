import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';

mixin LoadingOverlayMixin on GetxController {
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
}
