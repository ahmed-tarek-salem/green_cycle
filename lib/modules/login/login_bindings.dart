import 'package:get/get.dart';
import 'package:green_cycle/modules/login/login_controller.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
