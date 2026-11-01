import 'package:get/get.dart';
import 'package:green_cycle/modules/my_activities/my_activities_controller.dart';
import 'package:green_cycle/modules/my_activities/my_activities_repo.dart';

class MyActivitiesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyActivitiesRepo());
    Get.lazyPut(() => MyActivitiesController());
  }
}
