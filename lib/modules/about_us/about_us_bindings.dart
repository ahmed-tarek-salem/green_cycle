import 'package:get/get.dart';
import 'package:green_cycle/modules/about_us/about_us_controller.dart';

class AboutUsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AboutUsController());
  }
}
