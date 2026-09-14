import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/carpool/carpool_controller.dart';
import 'package:green_cycle/modules/carpool/carpool_utils.dart';
import 'package:green_cycle/modules/carpool/widgets/route_chain.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';

class MyOfferScreen extends StatelessWidget {
  const MyOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CarpoolController>();
    return Scaffold(
      appBar: returnHomeAppBar('رحلتي'),
      body: GetBuilder<CarpoolController>(
        init: controller,
        builder: (_) {
          final offer = controller.myOffer.value;
          if (offer == null || !offer.isActive) {
            return const Center(child: Text('لا يوجد عرض نشط'));
          }
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
              vertical: AppConstants.topPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('المواعيد', style: Get.textTheme.headlineSmall),
                        SizedBox(height: 8.h),
                        ...offer.weeklySchedule.map((s) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(CarpoolDays.label(s.dayOfWeek)),
                                  Text(s.arrivalTime),
                                ],
                              ),
                            )),
                        SizedBox(height: 16.h),
                        Text('خط السير', style: Get.textTheme.headlineSmall),
                        SizedBox(height: 8.h),
                        RouteChain(
                          stops: offer.checkpoints
                              .map((c) =>
                                  (id: c.district.id, name: c.district.nameAr))
                              .toList(),
                        ),
                        if (offer.notes != null &&
                            offer.notes!.trim().isNotEmpty) ...[
                          SizedBox(height: 16.h),
                          Text('ملاحظات', style: Get.textTheme.headlineSmall),
                          SizedBox(height: 8.h),
                          Text(offer.notes!),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                PrimaryButton(
                  text: 'تعديل',
                  onTap: () => Get.toNamed(AppRoutes.carpoolDriverSetupScreen),
                ),
                SizedBox(height: 12.h),
                PrimaryButton(
                  text: 'إيقاف العرض',
                  backgroundColor: AppColors.white,
                  textColor: AppColors.danger,
                  borderColor: AppColors.danger,
                  onTap: () => _confirmDeactivate(controller),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDeactivate(CarpoolController controller) {
    Get.defaultDialog(
      title: 'إيقاف العرض',
      middleText: 'هل تريد إيقاف عرضك؟ لن يظهر للباحثين بعد الآن.',
      textCancel: 'إلغاء',
      textConfirm: 'إيقاف',
      confirmTextColor: AppColors.white,
      buttonColor: AppColors.danger,
      onConfirm: () {
        Get.back(); // close dialog
        controller.deactivate();
      },
    );
  }
}
