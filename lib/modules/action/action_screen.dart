import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/action/action_controller.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/shared_widgets/image_picker_widget.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/shared_widgets/primary_text_field.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';
import 'package:image_picker/image_picker.dart';

class ActionScreen extends GetView<ActionController> {
  const ActionScreen({super.key});
  final formattedText = '''
1- قم بالنشاط البيئي، مثل تسليم المخلفات في أقرب صندوق إعادة تدوير من قسم الخرائط
2- التقط صورة واضحة أثناء النشاط، على أن تكون يدك والنشاط ظاهرين فيها
3- ستتم مراجعة الصورة من الإدارة ثم منحك النقاط الخضراء
''';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnHomeAppBar('أضف مشاركة بيئية'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
            vertical: AppConstants.topPadding),
        child: Column(
          children: [
            Text(
              'تعليمات للحصول على النقاط الخضراء:',
              style: Get.textTheme.headlineMedium,
            ),
            SizedBox(height: 20.h),
            Text(formattedText),
            SizedBox(height: 10.h),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: InkWell(
                onTap: () => Get.toNamed(AppRoutes.faqScreen),
                child: Text(
                  'لمعرفة كل الأنشطة ونقاطها راجع الأسئلة الشائعة',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ImagePickerWidget(onSelected: (XFile image) {
              controller.image = image;
            }),
            SizedBox(height: 20.h),
            PrimaryTextField(
              hintText: 'أضف وصفاً (اختياري)',
              maxLines: 2,
              controller: controller.actionDetailsController,
            ),
            SizedBox(height: 30.h),
            PrimaryButton(onTap: controller.submitAction, text: 'تأكيد')
          ],
        ),
      ),
    );
  }
}
