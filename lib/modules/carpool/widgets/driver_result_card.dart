import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/carpool_search_response_model.dart';
import 'package:green_cycle/modules/carpool/widgets/route_chain.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class DriverResultCard extends StatelessWidget {
  final CarpoolSearchResult offer;
  final String passengerDistrictId;
  final VoidCallback onContact;

  const DriverResultCard({
    super.key,
    required this.offer,
    required this.passengerDistrictId,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final arrival = offer.scheduleForDay?.arrivalTime;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.greyD5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22.sp,
                backgroundColor: AppColors.secondary,
                backgroundImage: offer.driver.avatar.isEmpty
                    ? null
                    : CachedNetworkImageProvider(offer.driver.avatar),
                child: offer.driver.avatar.isEmpty
                    ? const Icon(Icons.person, color: AppColors.primary)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child:
                    Text(offer.driver.name, style: Get.textTheme.headlineSmall),
              ),
              if (arrival != null && arrival.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 14.sp, color: AppColors.primary),
                    SizedBox(width: 4.w),
                    Text(arrival, style: TextStyle(fontSize: 12.sp)),
                  ],
                ),
            ],
          ),
          SizedBox(height: 12.h),
          RouteChain(
            stops: offer.checkpoints
                .map((c) => (id: c.district.id, name: c.district.nameAr))
                .toList(),
            highlightId: passengerDistrictId,
          ),
          if (offer.notes != null && offer.notes!.trim().isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(offer.notes!,
                style: TextStyle(fontSize: 12.sp, color: AppColors.grey5B)),
          ],
          SizedBox(height: 14.h),
          PrimaryButton(
            text: 'تواصل عبر واتساب',
            onTap: onContact,
          ),
        ],
      ),
    );
  }
}
