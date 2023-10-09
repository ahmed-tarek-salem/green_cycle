import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/action/action_controller.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/shared_widgets/image_picker_widget.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/shared_widgets/primary_text_field.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:image_picker/image_picker.dart';

class ActionScreen extends GetView<ActionController> {
  const ActionScreen({super.key});
  final formattedText = '''
1- توجه لأقرب صندوق إعادة تدوير لك من خلال قسم الخرائط
2- قم بالتخلص من النفايات في الصندوق المناسب
3- التقط صورة وأنت تتخلص من النفايات, على يدك أن تكون ظاهرة وأن يكون الصندوق ظاهرا وقطعة النفايات
4- ستتم مراجعة الصورة ثم منحك النقاط الخضراء!
5- يمكنك تكرار ذلك مرة واحدة كل أسبوع للحصول على المزيد من النقاط
''';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnHomeAppBar('استخدم الصناديق'),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
            vertical: AppConstants.topPadding),
        child: Column(
          children: [
            Text(
              'تعلميات للحصول على النقاط الخضراء:',
              style: Get.textTheme.headlineMedium,
            ),
            SizedBox(height: 20.h),
            Text(formattedText),
            ImagePickerWidget(onSelected: (XFile image) {
              controller.image = image;
            }),
            SizedBox(height: 20.h),
            PrimaryTextField(
              hintText: 'أضف وصفاً (اختياري)',
              maxLines: 2,
            ),
            const Spacer(),
            PrimaryButton(onTap: controller.submitAction, text: 'تأكيد')
          ],
        ),
      ),
    );
  }
}
