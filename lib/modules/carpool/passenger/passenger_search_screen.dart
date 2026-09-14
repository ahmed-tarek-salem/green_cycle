import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/carpool/carpool_utils.dart';
import 'package:green_cycle/modules/carpool/passenger/passenger_search_controller.dart';
import 'package:green_cycle/modules/carpool/widgets/district_picker_sheet.dart';
import 'package:green_cycle/modules/carpool/widgets/driver_result_card.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class PassengerSearchScreen extends StatelessWidget {
  const PassengerSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnHomeAppBar('أبحث عن مشوار'),
      body: GetBuilder<PassengerSearchController>(
        init: PassengerSearchController(),
        builder: (controller) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
            vertical: AppConstants.topPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _districtField(controller),
              SizedBox(height: 12.h),
              _dayPicker(controller),
              SizedBox(height: 16.h),
              PrimaryButton(
                text: 'بحث',
                isLoading: controller.searching.value,
                onTap: controller.selectedDistrict.value == null
                    ? null
                    : controller.runSearch,
              ),
              SizedBox(height: 16.h),
              Expanded(child: _results(controller)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _districtField(PassengerSearchController controller) {
    final selected = controller.selectedDistrict.value;
    return InkWell(
      onTap: () async {
        final picked = await showDistrictPicker(controller.districts);
        if (picked != null) controller.selectDistrict(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'منطقتك',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        child: Text(selected?.nameAr ?? 'اختر المنطقة'),
      ),
    );
  }

  Widget _dayPicker(PassengerSearchController controller) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: CarpoolDays.all.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final day = CarpoolDays.all[i];
          final selected = controller.selectedDay.value == day;
          return ChoiceChip(
            label: Text(CarpoolDays.label(day)),
            selected: selected,
            selectedColor: AppColors.secondary,
            onSelected: (_) => controller.selectDay(day),
          );
        },
      ),
    );
  }

  Widget _results(PassengerSearchController controller) {
    if (controller.searching.value) return const CustomProgressIndicator();
    if (!controller.hasSearched.value) {
      return const SizedBox();
    }
    if (controller.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_outlined,
                size: 48.sp, color: AppColors.greyA3),
            SizedBox(height: 12.h),
            const Text('لا يوجد سائقون متاحون لهذه المنطقة واليوم'),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: controller.results.length,
      itemBuilder: (_, i) {
        final offer = controller.results[i];
        return DriverResultCard(
          offer: offer,
          passengerDistrictId: controller.selectedDistrict.value!.id,
          onContact: () => controller.contactDriver(offer),
        );
      },
    );
  }
}
