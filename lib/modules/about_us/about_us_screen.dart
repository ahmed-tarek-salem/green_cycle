import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/theme/app_images.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});
  final aboutustext =
      "تحت رعاية أ.د. ميرفت أمين قاسم عميد كلية الصيدلة-جامعة الإسكندرية و أ.د. شريف أحمد رستم وكيل الكليةلشؤون خدمة المجتمع و تنمية البيئة و تحت إشراف د. سماح الصحفي الأستاذ مساعد بقسم العقاقير و د. سارة عبدالله اللقاني المدرس بقسم الصيدلة الصناعية قام مجموعة من طلاب و خريجين كلية الصيدلة جامعة الإسكندرية و هم : أحمد طارق وأحمد عبدالستار وعبدالرحمن شريف وباسل فتحي سعيد (خريجو دفعة ٢٠٢٣) وعمر العبد (الفرقة الخامسة فارم دى) بالتعاون مع  مهندسة آية سليمان (هندسة ٢٠١٩) ومهندسة ميار سامي (حاسبات و معلومات ٢٠١٩) باستحداث تطبيق مُعد للهواتف الذكية، يهدف إلى تقليل البصمة الكربونية الفردية للطلاب وأعضاء هيئة التدريس والعاملين بكلية الصيدلة ويمكنهم من المشاركة الفعالة في مبادرة Green Cycle حيث سيتم تحميل التطبيق بشكلٍ مجاني تمامًا من خلال إيميل الجامعة. ‎ولتشجيع الطلاب على استخدام هذا التطبيق والمشاركة الفعالة في المبادرة، يتيح هذا التطبيق لهم الحصول على نقاط خضراء من خلال المشاركة في إعادة تدوير النفايات، وكلما زادت المشاركة زاد عدد النقاط وفرص الفوز بإحدى الجوائز المقررة ومنها المشاركة في مؤتمر الكلية العالمي ٢٠٢٤ مجانا . ‎وسوف يقوم التطبيق بتنبيه المستخدم، من خلال إشعار، بمواعيد إحضار النفايات التي يمكن إعادة تدويرها من المنزل مما يسهم في خلق أثر إيجابي على المجتمع والبيئة اللذان ينفذ فيهما المشروع.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnHomeAppBar('من نحن'),
      body: ListView(
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
          // Text(aboutustext)
        ],
      ),
    );
  }
}
