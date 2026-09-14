import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/carpool/carpool_controller.dart';
import 'package:green_cycle/modules/carpool/carpool_utils.dart';
import 'package:green_cycle/modules/carpool/driver/driver_setup_controller.dart';
import 'package:green_cycle/modules/carpool/widgets/day_schedule_row.dart';
import 'package:green_cycle/modules/carpool/widgets/district_picker_sheet.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class DriverSetupScreen extends StatelessWidget {
  const DriverSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final editing = Get.find<CarpoolController>().hasActiveOffer;
    return Scaffold(
      appBar: returnHomeAppBar(editing ? 'تعديل رحلتي' : 'إعداد رحلتي'),
      body: GetBuilder<DriverSetupController>(
        init: DriverSetupController(),
        builder: (controller) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
            vertical: AppConstants.topPadding,
          ),
          child: Column(
            children: [
              Expanded(child: _stepBody(context, controller)),
              _footer(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepBody(BuildContext context, DriverSetupController c) {
    switch (c.step.value) {
      case 0:
        return _scheduleStep(context, c);
      case 1:
        return _routeStep(c);
      default:
        return _notesStep(c);
    }
  }

  Widget _scheduleStep(BuildContext context, DriverSetupController c) {
    return ListView(
      children: [
        Text('اختر أيام رحلتك ومواعيد الوصول',
            style: Get.textTheme.headlineSmall),
        SizedBox(height: 12.h),
        ...CarpoolDays.all.map((day) {
          final enabled = c.schedule.containsKey(day);
          return DayScheduleRow(
            label: CarpoolDays.label(day),
            enabled: enabled,
            time: c.schedule[day],
            onToggle: (on) => c.toggleDay(day, on),
            onPickTime: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: parseHHmm(c.schedule[day] ?? '08:00'),
              );
              if (picked != null) c.setDayTime(day, picked);
            },
          );
        }),
      ],
    );
  }

  Widget _routeStep(DriverSetupController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('خط سيرك (اسحب لإعادة الترتيب)',
            style: Get.textTheme.headlineSmall),
        SizedBox(height: 8.h),
        OutlinedButton.icon(
          onPressed: () async {
            final picked = await showDistrictPicker(
              c.allDistricts,
              excludeIds: c.selectedCheckpoints.map((d) => d.id).toSet(),
            );
            if (picked != null) c.addCheckpoint(picked);
          },
          icon: const Icon(Icons.add, color: AppColors.primary),
          label: const Text('أضف منطقة'),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ReorderableListView(
            onReorder: c.reorderCheckpoints,
            children: [
              for (final d in c.selectedCheckpoints)
                ListTile(
                  key: ValueKey(d.id),
                  leading:
                      const Icon(Icons.drag_handle, color: AppColors.grey85),
                  title: Text(d.nameAr),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.danger),
                    onPressed: () => c.removeCheckpoint(d.id),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              const Icon(Icons.school, color: AppColors.primary),
              SizedBox(width: 8.w),
              Expanded(child: Text('الوجهة: $kCarpoolDestinationAr')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _notesStep(DriverSetupController c) {
    return ListView(
      children: [
        Text('ملاحظات (اختياري)', style: Get.textTheme.headlineSmall),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          children: ['سيدات فقط', 'مقعدان متاحان'].map((chip) {
            return ActionChip(
              label: Text(chip),
              onPressed: () {
                final text = c.notesController.text;
                c.notesController.text = text.isEmpty ? chip : '$text، $chip';
              },
            );
          }).toList(),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: c.notesController,
          maxLength: 500,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'مثال: أنطلق من سيدي بشر، مقعدان متاحان',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
        ),
      ],
    );
  }

  Widget _footer(DriverSetupController c) {
    final isLast = c.step.value == 2;
    return Row(
      children: [
        if (c.step.value > 0)
          Expanded(
            child: PrimaryButton(
              text: 'رجوع',
              backgroundColor: AppColors.white,
              textColor: AppColors.primary,
              onTap: c.back,
            ),
          ),
        if (c.step.value > 0) SizedBox(width: 12.w),
        Expanded(
          child: PrimaryButton(
            text: isLast
                ? (c.isEditing ? 'تحديث الرحلة' : 'نشر الرحلة')
                : 'التالي',
            onTap: isLast ? c.submit : c.next,
          ),
        ),
      ],
    );
  }
}
