import 'package:get/get.dart';
import 'package:green_cycle/modules/action/action_controller.dart';

class ActionBindigns extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActionController());
  }
}
