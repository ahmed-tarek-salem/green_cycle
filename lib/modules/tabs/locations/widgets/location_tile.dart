import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/tabs/locations/locations_controller.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class LocationTile extends StatelessWidget {
  final String name;
  final int index;
  final bool isActive;

  const LocationTile({
    required this.name,
    required this.index,
    required this.isActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.secondary,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
        child: Center(
            child: Text(
          name,
          style: TextStyle(color: isActive ? Colors.white : AppColors.primary),
        )),
      ),
    );
  }
}
