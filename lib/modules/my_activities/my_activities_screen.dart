import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/my_activities_response_model.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/modules/my_activities/my_activities_controller.dart';
import 'package:green_cycle/shared_widgets/custom_error_widget.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:intl/intl.dart';

class MyActivitiesScreen extends GetView<MyActivitiesController> {
  const MyActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnHomeAppBar('طلباتي'),
      body: GetBuilder(
        init: controller,
        builder: (_) {
          if (controller.isLoading) return const CustomProgressIndicator();
          if (controller.isError) {
            return CustomErrorWidget(onRefresh: controller.loadFirstPage);
          }
          return RefreshIndicator(
            onRefresh: controller.refreshList,
            child: MyActivitiesList(
              activities: controller.activities,
              onNearEnd: controller.loadMore,
            ),
          );
        },
      ),
    );
  }
}

class MyActivitiesList extends StatelessWidget {
  final List<MyActivity> activities;
  final VoidCallback onNearEnd;

  const MyActivitiesList({
    required this.activities,
    required this.onNearEnd,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      // A scrollable child, so pull to refresh still works when empty.
      return ListView(
        children: [
          SizedBox(height: 200.h),
          Center(
            child: Text(
              'لم ترفع أي نشاط بعد',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 300) onNearEnd();
        return false;
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
          vertical: AppConstants.topPadding,
        ),
        itemCount: activities.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (_, index) => MyActivityCard(activity: activities[index]),
      ),
    );
  }
}

class MyActivityCard extends StatelessWidget {
  final MyActivity activity;

  const MyActivityCard({required this.activity, super.key});

  @override
  Widget build(BuildContext context) {
    final createdAt = activity.createdAt;
    final statusColor = switch (activity.status) {
      MyActivityStatus.pending => AppColors.grey5B,
      MyActivityStatus.approved => AppColors.primary,
      MyActivityStatus.rejected => AppColors.danger,
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  activity.title.isEmpty ? '-' : activity.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    height: 1.4,
                  ),
                ),
              ),
              if (createdAt != null) ...[
                SizedBox(width: 8.w),
                Text(
                  DateFormat('yyyy/MM/dd').format(createdAt),
                  style: TextStyle(fontSize: 12.sp, color: AppColors.grey5B),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            activity.statusText,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: statusColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
