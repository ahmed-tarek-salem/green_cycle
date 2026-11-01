import 'package:get/get.dart';
import 'package:green_cycle/modules/rewards/rewards_controller.dart';
import 'package:green_cycle/modules/rewards/rewards_repo.dart';

class RewardsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RewardsRepo());
    Get.lazyPut(() => RewardsController());
  }
}
