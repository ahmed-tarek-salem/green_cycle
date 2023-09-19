import 'package:get/get.dart';
import 'package:green_cycle/modules/home_layout/home_layout_controller.dart';
import 'package:green_cycle/modules/tabs/locations/locations_controller.dart';

class HomeLayoutBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLayoutController());
    Get.lazyPut(() => LocationsController());
  }
}
