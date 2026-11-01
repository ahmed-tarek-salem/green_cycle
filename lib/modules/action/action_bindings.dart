import 'package:get/get.dart';
import 'package:green_cycle/modules/action/action_controller.dart';
import 'package:green_cycle/modules/rewards/rewards_repo.dart';

class ActionBindigns extends Bindings {
  @override
  void dependencies() {
    // The activity list comes from the same catalog as the rewards screen.
    Get.lazyPut(() => RewardsRepo());
    Get.lazyPut(() => ActionController());
  }
}
