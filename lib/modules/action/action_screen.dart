import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';
import 'package:green_cycle/modules/action/action_controller.dart';
import 'package:green_cycle/modules/action/activity_submission.dart';
import 'package:green_cycle/modules/action/widgets/activity_form_fields.dart';
import 'package:green_cycle/modules/action/widgets/activity_picker_list.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/modules/rewards/widgets/reward_action_card.dart';
import 'package:green_cycle/shared_widgets/custom_error_widget.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/shared_widgets/image_picker_widget.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/shared_widgets/primary_text_field.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:image_picker/image_picker.dart';

class ActionScreen extends GetView<ActionController> {
  const ActionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (_) {
        final selected = controller.selectedAction.value;
        return PopScope(
          // Back from the form returns to the activity list first.
          canPop: selected == null,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) controller.clearSelection();
          },
          child: Scaffold(
            appBar: returnHomeAppBar('أضف مشاركة بيئية'),
            body: _buildBody(selected),
          ),
        );
      },
    );
  }

  Widget _buildBody(RewardAction? selected) {
    if (controller.isLoading) return const CustomProgressIndicator();
    if (controller.isError) {
      return CustomErrorWidget(onRefresh: controller.loadActions);
    }
    if (selected == null) {
      return ActivityPickerList(
        actions: controller.actions,
        pendingSlugs: controller.pendingSlugs,
        onSelected: controller.selectAction,
      );
    }
    return _buildForm(selected);
  }

  Widget _buildForm(RewardAction action) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: AppConstants.topPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RewardActionCard(action: action),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: controller.clearSelection,
              child: Text(
                'تغيير النشاط',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          ActivityFormFields(
            action: action,
            variantKey: controller.variantKey.value,
            units: controller.units.value,
            onVariantSelected: controller.selectVariant,
            onUnitsChanged: controller.setUnits,
          ),
          SizedBox(height: 16.h),
          Text(
            'التقط صورة واضحة أثناء النشاط، على أن تكون يدك والنشاط ظاهرين فيها. '
            'إن كان نشاطك منشوراً، يكفي لصق رابطه. '
            'ستتم مراجعة مشاركتك من الإدارة ثم تضاف نقاطك.',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.grey5B,
              height: 1.5,
            ),
          ),
          SizedBox(height: 12.h),
          ImagePickerWidget(
            key: Key(controller.imageKeyIndex.value.toString()),
            onSelected: (XFile image) {
              controller.image = image;
            },
          ),
          SizedBox(height: 20.h),
          PrimaryTextField(
            hintText: 'أضف وصفاً أو رابط المنشور',
            maxLines: 2,
            maxLength: activityNotesMaxLength,
            controller: controller.actionDetailsController,
          ),
          SizedBox(height: 30.h),
          PrimaryButton(onTap: controller.submitAction, text: 'تأكيد'),
        ],
      ),
    );
  }
}
