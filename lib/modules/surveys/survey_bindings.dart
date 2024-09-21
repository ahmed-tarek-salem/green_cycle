import 'package:get/get.dart';
import 'package:green_cycle/modules/surveys/survey_controller.dart';
import 'package:green_cycle/modules/surveys/survey_repo.dart';

class SurveyBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SurveyRepo());
    Get.lazyPut(() => SurveyController());
  }
}
