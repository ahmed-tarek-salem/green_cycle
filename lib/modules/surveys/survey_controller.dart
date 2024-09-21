import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/survey_response_model.dart';
import 'package:green_cycle/modules/surveys/survey_repo.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class SurveyController extends BaseController {
  final _repo = Get.find<SurveyRepo>();
  final RxList<SurveyResponseModel> questions = RxList();

  @override
  void onInit() {
    if (isInit) {
      getSurveys();
      isInit = false;
    }
    super.onInit();
  }

  Future<void> getSurveys() async {
    try {
      setLoading = true;
      final data = await _repo.getSurveys();
      questions.addAll(data);
      setError = false;
      update();
    } catch (e) {
      setError = true;
      final exceptionMessage =
          (e is MyCustomException) ? e.message : AppConstants.error;
      showErrorDialog(exceptionMessage);
    } finally {
      setLoading = false;
    }
  }

  goToSurveyDetails(int index) {
    Get.toNamed(AppRoutes.surveyDetailsScreen, arguments: questions[index]);
  }
}
