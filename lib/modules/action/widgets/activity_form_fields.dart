import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';
import 'package:green_cycle/modules/action/activity_submission.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/global/points_label.dart';

/// The inputs that depend on the chosen activity: a variant choice, or a
/// quantity with its running total. Empty for a fixed-points activity.
class ActivityFormFields extends StatelessWidget {
  /// A sanity bound for the stepper, not a server rule.
  static const maxUnits = 99;

  final RewardAction action;
  final String? variantKey;
  final int units;
  final ValueChanged<String> onVariantSelected;
  final ValueChanged<int> onUnitsChanged;

  const ActivityFormFields({
    required this.action,
    required this.variantKey,
    required this.units,
    required this.onVariantSelected,
    required this.onUnitsChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (action.pointsMode == PointsMode.variants &&
        action.variants.isNotEmpty) {
      return _buildVariants();
    }
    if (action.pointsMode == PointsMode.perUnit) return _buildUnits();
    return const SizedBox();
  }

  Widget _label(String text) => Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      );

  Widget _buildVariants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('اختر النوع'),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            for (final variant in action.variants)
              _Choice(
                text: '${variant.labelAr}: ${pointsLabel(variant.points)}',
                selected: variant.key == variantKey,
                onTap: () => onVariantSelected(variant.key),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildUnits() {
    final unit = action.unitLabelAr;
    final total = submissionPoints(action, units: units);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(unit.isEmpty ? 'العدد' : 'العدد ($unit)'),
        SizedBox(height: 8.h),
        Row(
          children: [
            _StepButton(
              icon: Icons.remove,
              semanticLabel: 'تقليل العدد',
              onTap: units > 1 ? () => onUnitsChanged(units - 1) : null,
            ),
            SizedBox(
              width: 48.w,
              child: Text(
                '$units',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            _StepButton(
              icon: Icons.add,
              semanticLabel: 'زيادة العدد',
              onTap: units < maxUnits ? () => onUnitsChanged(units + 1) : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'الإجمالي: ${pointsLabel(total)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey5B,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _Choice({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary, width: 1.2),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onTap;

  const _StepButton({
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: enabled ? AppColors.primary : AppColors.greyD5,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Icon(icon, color: AppColors.white, size: 20.sp),
        ),
      ),
    );
  }
}
