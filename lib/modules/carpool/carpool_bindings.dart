import 'package:get/get.dart';
import 'package:green_cycle/modules/carpool/carpool_controller.dart';
import 'package:green_cycle/modules/carpool/carpool_repo.dart';

class CarpoolBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CarpoolRepo(), fenix: true);
    Get.lazyPut(() => CarpoolController(), fenix: true);
  }
}
