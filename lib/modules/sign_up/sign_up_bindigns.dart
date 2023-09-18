import 'package:get/get.dart';
import 'package:green_cycle/modules/sign_up/sign_up_controller.dart';

class SignUpBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
  }
}
