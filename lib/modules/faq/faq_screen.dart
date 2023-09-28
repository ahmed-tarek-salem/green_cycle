import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/faq/faq_controller.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/shared_widgets/custom_error_widget.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class FaqScreen extends GetView<FaqController> {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnHomeAppBar('الأسئلة الشائعة'),
      body: GetBuilder(
          init: controller,
          builder: (_) {
            if (controller.isLoading) {
              return const CustomProgressIndicator();
            } else if (controller.isError) {
              return CustomErrorWidget(onRefresh: () {
                controller.getFaqs();
              });
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalPadding,
                  vertical: AppConstants.topPadding),
              itemBuilder: (context, index) {
                final question = controller.questions[index];
                return ExpansionTile(
                  title: Text(question.question,
                      style: Get.textTheme.headlineSmall),
                  shape: Border(),
                  iconColor: AppColors.primary,
                  collapsedIconColor: AppColors.primary,
                  children: [
                    Text(
                      question.answer,
                      textAlign: TextAlign.right,
                    )
                  ],
                );
              },
              itemCount: controller.questions.length,
            );
          }),
    );
  }
}
