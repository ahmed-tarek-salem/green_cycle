import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/district_response_model.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

/// Bottom sheet for picking a single district. Returns the chosen [District]
/// or null if dismissed. [excludeIds] hides already-selected districts.
Future<District?> showDistrictPicker(
  List<District> districts, {
  Set<String> excludeIds = const {},
}) {
  return Get.bottomSheet<District>(
    _DistrictPickerSheet(districts: districts, excludeIds: excludeIds),
    isScrollControlled: true,
    backgroundColor: AppColors.white,
  );
}

class _DistrictPickerSheet extends StatefulWidget {
  final List<District> districts;
  final Set<String> excludeIds;

  const _DistrictPickerSheet(
      {required this.districts, required this.excludeIds});

  @override
  State<_DistrictPickerSheet> createState() => _DistrictPickerSheetState();
}

class _DistrictPickerSheetState extends State<_DistrictPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final available = widget.districts
        .where((d) => !widget.excludeIds.contains(d.id))
        .where((d) =>
            _query.isEmpty ||
            d.nameAr.contains(_query) ||
            d.nameEn.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.75.sh),
        padding: EdgeInsets.all(16.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'ابحث عن منطقة',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadius),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Flexible(
              child: available.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(24.sp),
                      child: const Text('لا توجد نتائج'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: available.length,
                      itemBuilder: (_, i) => ListTile(
                        title: Text(available[i].nameAr),
                        onTap: () => Get.back(result: available[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
