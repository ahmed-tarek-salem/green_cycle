import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/app_update/app_update_controller.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/theme/app_images.dart';

/// Full-screen block shown when the installed version is no longer supported.
/// `AppUpdateListener` stacks it above the navigator, so no route change can
/// cover or remove it. The user's only option is to hand off to the store.
class ForceUpdateScreen extends StatefulWidget {
  const ForceUpdateScreen({super.key});

  @override
  State<ForceUpdateScreen> createState() => _ForceUpdateScreenState();
}

class _ForceUpdateScreenState extends State<ForceUpdateScreen> {
  final AppUpdateController _controller = Get.find<AppUpdateController>();
  bool _opening = false;

  Future<void> _handleUpdate() async {
    if (_opening) return;
    setState(() => _opening = true);
    await _controller.openStore();
    if (!mounted) return;
    setState(() => _opening = false);
  }

  @override
  Widget build(BuildContext context) {
    final settings = _controller.settings;
    final releaseNotes = settings?.releaseNotes;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: DefaultTextStyle.merge(
        style: const TextStyle(color: AppColors.white),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Centered while it fits, scrollable once long release notes
                // or a small screen make it taller than the viewport.
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(child: _Logo()),
                          SizedBox(height: 32.sp),
                          Text(
                            'تحديث مطلوب',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24.sp, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 12.sp),
                          Text(
                            'هذا الإصدار لم يعد مدعوماً. برجاء تحديث التطبيق للمتابعة.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w300,
                              height: 1.5,
                            ),
                          ),
                          if (releaseNotes != null) ...[
                            SizedBox(height: 24.sp),
                            _WhatsNewCard(message: releaseNotes),
                          ],
                          if (settings != null) ...[
                            SizedBox(height: 24.sp),
                            _VersionRow(
                              label: 'الإصدار الحالي',
                              value: _controller.currentVersion,
                            ),
                            SizedBox(height: 8.sp),
                            _VersionRow(
                              label: 'أحدث إصدار',
                              value: settings.latestVersion,
                              highlight: true,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.sp),
                // No store listing published yet: keep the message, drop the CTA.
                if (_controller.storeUrl.isNotEmpty)
                  SizedBox(
                    height: 46.h,
                    child: ElevatedButton(
                      onPressed: _opening ? null : _handleUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                      ),
                      child: _opening
                          ? CustomProgressIndicator(
                              size: 24.sp,
                              color: AppColors.primary,
                            )
                          // Full theme style on purpose: the app-wide
                          // ElevatedButton text style carries no Arabic font.
                          : Text(
                              'تحديث الآن',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                            ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
      ),
      child: Image.asset(AppImages.logoPng, height: 110.h),
    );
  }
}

class _WhatsNewCard extends StatelessWidget {
  const _WhatsNewCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.white,
                size: 18.sp,
              ),
              SizedBox(width: 8.sp),
              Text(
                'ما الجديد',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 8.sp),
          Text(
            message,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.white.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionRow extends StatelessWidget {
  const _VersionRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.white.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(width: 8.sp),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
          decoration: BoxDecoration(
            color: highlight
                ? AppColors.white
                : AppColors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.sp),
            border: highlight
                ? null
                : Border.all(color: AppColors.white.withValues(alpha: 0.4)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: highlight ? AppColors.primary : AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
