import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:green_cycle/modules/app_update/app_update_controller.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/theme/app_colors.dart';

/// Dismissible bottom sheet shown when a newer version exists but the
/// installed one is still supported. "Later", tapping outside and the back
/// button all dismiss it, and every path marks the prompt as dismissed for
/// the session.
///
/// Shown through SmartDialog instead of a navigator route: the answer usually
/// arrives while the launch redirects (splash, sign up, home) are still
/// running, and those would bury or replace a route-based sheet.
abstract class OptionalUpdateDialog {
  static const String _tag = 'optional_update_dialog';

  static Future<void> show({required AppUpdateController controller}) async {
    await SmartDialog.show(
      tag: _tag,
      alignment: Alignment.bottomCenter,
      bindPage: false,
      onDismiss: () => controller.optionalDismissed = true,
      builder: (_) => _OptionalUpdateSheet(controller: controller),
    );
  }

  static Future<void> dismiss() => SmartDialog.dismiss(tag: _tag);
}

class _OptionalUpdateSheet extends StatefulWidget {
  const _OptionalUpdateSheet({required this.controller});

  final AppUpdateController controller;

  @override
  State<_OptionalUpdateSheet> createState() => _OptionalUpdateSheetState();
}

class _OptionalUpdateSheetState extends State<_OptionalUpdateSheet> {
  bool _opening = false;

  Future<void> _handleUpdate() async {
    if (_opening) return;
    setState(() => _opening = true);
    await widget.controller.openStore();
    await OptionalUpdateDialog.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.controller.settings;
    final releaseNotes = settings?.releaseNotes;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.sp)),
      child: SafeArea(
        top: false,
        // Scrolls instead of overflowing when the release notes are long.
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 28.sp, 20.w, 20.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'تحديث متاح',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 6.sp),
              Text(
                'إصدار جديد من التطبيق جاهز للتثبيت',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.grey5B,
                  height: 1.4,
                ),
              ),
              if (releaseNotes != null) ...[
                SizedBox(height: 20.sp),
                _WhatsNewCard(message: releaseNotes),
              ],
              if (settings != null) ...[
                SizedBox(height: 20.sp),
                _VersionComparison(
                  currentVersion: widget.controller.currentVersion,
                  latestVersion: settings.latestVersion,
                ),
              ],
              SizedBox(height: 24.sp),
              // No store listing published yet: keep the message, drop the CTA.
              if (widget.controller.storeUrl.isNotEmpty)
                PrimaryButton(
                  text: 'تحديث الآن',
                  isLoading: _opening,
                  onTap: _handleUpdate,
                ),
              SizedBox(height: 4.sp),
              TextButton(
                onPressed: OptionalUpdateDialog.dismiss,
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 46.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                ),
                child: Text(
                  'لاحقاً',
                  style: TextStyle(color: AppColors.greyA3, fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WhatsNewCard extends StatelessWidget {
  const _WhatsNewCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.primary,
                size: 16.sp,
              ),
              SizedBox(width: 6.sp),
              Text(
                'ما الجديد',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.sp),
          Text(
            message,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.grey5B,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionComparison extends StatelessWidget {
  const _VersionComparison({
    required this.currentVersion,
    required this.latestVersion,
  });

  final String currentVersion;
  final String latestVersion;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _VersionChip(value: currentVersion, highlight: false),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Icon(
            Icons.arrow_forward_rounded,
            size: 18.sp,
            color: AppColors.greyA3,
          ),
        ),
        _VersionChip(value: latestVersion, highlight: true),
      ],
    );
  }
}

class _VersionChip extends StatelessWidget {
  const _VersionChip({required this.value, required this.highlight});

  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primary : AppColors.greyVeryLighF5,
        borderRadius: BorderRadius.circular(16.sp),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: highlight ? AppColors.white : AppColors.grey5B,
        ),
      ),
    );
  }
}
