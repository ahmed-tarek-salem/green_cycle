import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/main.dart';
import 'package:green_cycle/models/response_models/survey_response_model.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/modules/survey_details/survey_details_controller.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class SurveryDetailsScreen extends GetView<SurveyDetailsController> {
  const SurveryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnHomeAppBar('تفاصيل السؤال'),
      body: GetBuilder(
          init: controller,
          builder: (context) {
            final survey = controller.survey;
            return Padding(
              padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalPadding)
                  .copyWith(bottom: 40, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(survey.title ?? "-", style: Get.textTheme.titleLarge),
                  const SizedBox(height: 20),
                  Expanded(
                      child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const Divider(height: 40),
                          itemCount: survey.questions?.length ?? 0,
                          itemBuilder: (context, index) {
                            final question = survey.questions![index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question.questionText ?? "-",
                                  style: Get.textTheme.titleMedium,
                                ),
                                if (question.questionType ==
                                    QuestionType.mcq.name)
                                  ...question.options!
                                      .map((e) => RadioListTile<String>(
                                            value: e,
                                            activeColor: AppColors.primary,
                                            groupValue: controller
                                                .responses[index].answer,
                                            onChanged: (value) {
                                              controller.addResponse(
                                                  index, value!);
                                            },
                                            title: Text(e ?? "-"),
                                          ))
                              ],
                            );
                          })),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: controller.submitSurvey,
                        child: Text("تأكيد")),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

enum QuestionType { mcq, text }
