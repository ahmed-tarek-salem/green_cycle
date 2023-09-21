import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnHomeAppBar('الأسئلة الشائعة'),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
            vertical: AppConstants.topPadding),
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text('سؤال  مهم جداً', style: Get.textTheme.headlineSmall),
            shape: Border(),
            iconColor: AppColors.primary,
            collapsedIconColor: AppColors.primary,
            children: [
              Text(
                  'هل تعلم أن بإمكانك لوريم ايبسوم دولار سيت أميت ,كونسيكتيتور  دو أيوسمود تيمبور أنكايديديونتيوت لابوري ات دولار ماجنا أليكيوا . يوت انيم أد مينيم فينايم,كيواس نوستريد أكسير سيتاشن يللأمكو لابورأس نيسي يت أليكيوب أكس أيا كوممودو ')
            ],
          );
        },
        itemCount: 30,
      ),
    );
  }
}
