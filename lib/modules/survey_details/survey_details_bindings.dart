import 'package:get/get.dart';
import 'package:green_cycle/modules/survey_details/surver_details_repo.dart';
import 'package:green_cycle/modules/survey_details/survey_details_controller.dart';

class SurveyDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SurveyDetailsRepo());
    Get.lazyPut(
      () => SurveyDetailsController(),
    );
  }
}
