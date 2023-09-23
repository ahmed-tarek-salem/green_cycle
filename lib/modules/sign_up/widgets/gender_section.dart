import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/sign_up/sign_up_controller.dart';
import 'package:green_cycle/modules/sign_up/widgets/gender_radio_button.dart';

class GenderSection extends StatelessWidget {
  const GenderSection({
    super.key,
    required this.controller,
  });

  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        id: 'gender',
        builder: (_) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('النوع:'),
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: () {
                  controller.setGender(Gender.male);
                },
                child: GenderRadioButton(
                  index: 0,
                  isActive: controller.gender.value.index == 0,
                  title: 'ذكر',
                ),
              ),
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: () {
                  controller.setGender(Gender.female);
                },
                child: GenderRadioButton(
                  index: 1,
                  isActive: controller.gender.value.index == 1,
                  title: 'انثى',
                ),
              ),
            ],
          );
        });
  }
}
