import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/modules/rewards/rewards_controller.dart';
import 'package:green_cycle/modules/rewards/widgets/rewards_catalog_view.dart';
import 'package:green_cycle/shared_widgets/custom_error_widget.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';

class RewardsScreen extends GetView<RewardsController> {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnHomeAppBar('المكافآت'),
      body: GetBuilder(
        init: controller,
        builder: (_) {
          final catalog = controller.catalog.value;
          if (controller.isLoading) {
            return const CustomProgressIndicator();
          }
          if (controller.isError || catalog == null) {
            return CustomErrorWidget(onRefresh: controller.loadCatalog);
          }
          return RewardsCatalogView(
            catalog: catalog,
            totalPoints: controller.totalPoints,
            initialTab: controller.initialTab,
            onRefresh: controller.refreshCatalog,
          );
        },
      ),
    );
  }
}
