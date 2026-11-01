import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/theme/app_colors.dart';

class PromptAction<T> {
  final String label;
  final T value;

  /// Filled green button. Others are outlined.
  final bool primary;

  const PromptAction(this.label, this.value, {this.primary = false});
}

/// A question or notice from the server that needs the student's attention.
/// Closes with the value of the tapped action.
class PromptDialog<T> extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final List<PromptAction<T>> actions;

  const PromptDialog({
    required this.icon,
    required this.title,
    required this.body,
    required this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 48.sp),
          SizedBox(height: 12.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.grey5B,
              height: 1.5,
            ),
          ),
          SizedBox(height: 20.h),
          for (final action in actions) ...[
            SizedBox(
              width: double.infinity,
              child: action.primary
                  ? ElevatedButton(
                      onPressed: () => Navigator.pop(context, action.value),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(action.label),
                    )
                  : OutlinedButton(
                      onPressed: () => Navigator.pop(context, action.value),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(action.label),
                    ),
            ),
            SizedBox(height: 8.h),
          ],
        ],
      ),
    );
  }
}
