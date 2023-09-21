import 'package:get/get.dart';
import 'package:green_cycle/modules/faq/faq_controller.dart';

class FaqBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FaqController());
  }
}
