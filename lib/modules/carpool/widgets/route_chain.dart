import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/theme/app_colors.dart';

/// Renders district names as a route: سيدي بشر ← سموحة ← الكلية.
/// [highlightId] (optional) bolds the passenger's district.
class RouteChain extends StatelessWidget {
  final List<({String id, String name})> stops;
  final String? highlightId;

  const RouteChain({super.key, required this.stops, this.highlightId});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (var i = 0; i < stops.length; i++) {
      final stop = stops[i];
      final highlighted = stop.id == highlightId;
      items.add(Text(
        stop.name,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.primary,
          fontWeight: highlighted ? FontWeight.w700 : FontWeight.w400,
          decoration: highlighted ? TextDecoration.underline : null,
        ),
      ));
      if (i != stops.length - 1) {
        items.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Icon(Icons.arrow_back, size: 14.sp, color: AppColors.grey85),
        ));
      }
    }
    // Append the destination (faculty) as the final stop.
    items.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Icon(Icons.arrow_back, size: 14.sp, color: AppColors.grey85),
    ));
    items.add(Text(
      'الكلية',
      style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.primary,
          fontWeight: FontWeight.w600),
    ));

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 4.h,
      children: items,
    );
  }
}
