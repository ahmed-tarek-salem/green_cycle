import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/modules/surveys/survey_controller.dart';
import 'package:green_cycle/shared_widgets/custom_error_widget.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/global/points_label.dart';

class SurveysScreen extends GetView<SurveyController> {
  const SurveysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnHomeAppBar('استطلاعات الرأي'),
      body: GetBuilder(
          init: controller,
          builder: (_) {
            if (controller.isLoading) {
              return const CustomProgressIndicator();
            } else if (controller.isError) {
              return CustomErrorWidget(onRefresh: () {
                controller.getSurveys();
              });
            }
            if (controller.questions.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد استطلاعات حالياً',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalPadding,
                  vertical: AppConstants.topPadding),
              itemBuilder: (context, index) {
                final survey = controller.questions[index];

                return GestureDetector(
                  onTap: () {
                    controller.goToSurveyDetails(index);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primary),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalPadding,
                        vertical: AppConstants.topPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          survey.title ?? "-",
                          style: Get.textTheme.titleMedium!
                              .copyWith(fontSize: 18.sp),
                        ),
                        if (survey.answeredByMe || survey.rewardPoints > 0) ...[
                          SizedBox(height: 6.h),
                          Text(
                            survey.answeredByMe
                                ? '✓ تمت الإجابة'
                                : 'أجب واحصل على ${pointsLabel(survey.rewardPoints)}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: survey.answeredByMe
                                  ? AppColors.grey5B
                                  : AppColors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemCount: controller.questions.length,
            );
          }),
    );
  }
}
