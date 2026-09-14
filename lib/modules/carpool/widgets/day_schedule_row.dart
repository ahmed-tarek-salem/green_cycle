import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/theme/app_colors.dart';

class DayScheduleRow extends StatelessWidget {
  final String label;
  final bool enabled;
  final String? time; // "HH:MM" when enabled
  final ValueChanged<bool> onToggle;
  final VoidCallback onPickTime;

  const DayScheduleRow({
    super.key,
    required this.label,
    required this.enabled,
    required this.time,
    required this.onToggle,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Switch(
            value: enabled,
            activeThumbColor: AppColors.primary,
            onChanged: onToggle,
          ),
          SizedBox(width: 8.w),
          Expanded(child: Text(label, style: TextStyle(fontSize: 14.sp))),
          if (enabled)
            TextButton.icon(
              onPressed: onPickTime,
              icon: Icon(Icons.access_time,
                  size: 18.sp, color: AppColors.primary),
              label: Text(time ?? '08:00',
                  style: const TextStyle(color: AppColors.primary)),
            ),
        ],
      ),
    );
  }
}
