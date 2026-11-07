import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/about_us_response_model.dart';
import 'package:green_cycle/modules/about_us/about_us_controller.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/shared_widgets/custom_cached_network_image.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/theme/app_images.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class AboutUsScreen extends GetView<AboutUsController> {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnHomeAppBar('من نحن'),
      body: GetBuilder(
        init: controller,
        builder: (_) {
          final aboutUs = controller.aboutUs;
          return ListView(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding,
                vertical: AppConstants.topPadding),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                child: Image.asset(
                  AppImages.team,
                  width: double.infinity,
                  height: 280.h,
                ),
              ),
              Text(
                'Green Cycle',
                textAlign: TextAlign.center,
                style: Get.textTheme.titleLarge,
              ),
              // The text and team come from the dashboard. If they fail to
              // load, the page keeps the part above.
              if (controller.isLoading)
                Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: const CustomProgressIndicator(),
                )
              else if (aboutUs != null) ...[
                if (aboutUs.text.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Text(
                    aboutUs.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, height: 1.6),
                  ),
                ],
                if (aboutUs.members.isNotEmpty) ...[
                  SizedBox(height: 28.h),
                  Text('فريق العمل', style: Get.textTheme.titleMedium),
                  SizedBox(height: 12.h),
                  ...aboutUs.members.map((m) => TeamMemberTile(member: m)),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

class TeamMemberTile extends StatelessWidget {
  final TeamMember member;
  const TeamMemberTile({required this.member, super.key});

  @override
  Widget build(BuildContext context) {
    final photoSize = 52.r;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          ClipOval(
            child: member.photo == null
                ? Container(
                    width: photoSize,
                    height: photoSize,
                    color: AppColors.secondary,
                    alignment: Alignment.center,
                    child: Text(
                      member.name.characters.first,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : CustomCachedNetworkImage(
                    height: photoSize,
                    width: photoSize,
                    imageUrl: member.photo,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.displayName,
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                ),
                if (member.role.isNotEmpty)
                  Text(
                    member.role,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
