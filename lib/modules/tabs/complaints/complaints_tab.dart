import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/tabs/complaints/complaints_controller.dart';
import 'package:green_cycle/shared_widgets/image_picker_widget.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/shared_widgets/primary_text_field.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';

class ComplaintsTab extends GetView<ComplaintsController> {
  const ComplaintsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
      child: Form(
        key: controller.formKey,
        child: ListView(
          children: [
            SizedBox(height: AppConstants.topPadding),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.faqScreen);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius)),
                child: Center(
                  child: Text(
                    'الأسئلة الأكثر شيوعاً',
                    style:
                        TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            PrimaryTextField(
              hintText: 'عنوان الشكوى أو الاقتراح',
              controller: controller.complaintTitleController,
              validator: FormBuilderValidators.required(),
            ),
            SizedBox(height: 15.h),
            PrimaryTextField(
              hintText: 'تفاصيل الشكوى أو الاقتراح',
              maxLines: 4,
              controller: controller.complaintDetailsController,
              validator: FormBuilderValidators.required(),
            ),
            SizedBox(height: 15.h),
            GetBuilder(
                init: controller,
                builder: (context) {
                  log(controller.imageKeyIndex.value.toString());
                  return ImagePickerWidget(
                    key: Key(controller.imageKeyIndex.value.toString()),
                    onSelected: (image) {
                      controller.image = image;
                    },
                  );
                }),
            SizedBox(height: 20.h),
            PrimaryButton(
                onTap: () {
                  controller.submitComplaint();
                },
                text: 'رفع الشكوى او الاقتراح'),
            SizedBox(height: 25.h),
          ],
        ),
      ),
    );
  }
}
