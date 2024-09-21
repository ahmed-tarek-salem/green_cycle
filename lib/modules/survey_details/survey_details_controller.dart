import 'package:get/get.dart';
import 'package:green_cycle/models/request_models/survey_request_model.dart';
import 'package:green_cycle/models/response_models/survey_response_model.dart';
import 'package:green_cycle/modules/survey_details/surver_details_repo.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class SurveyDetailsController extends BaseController {
  final _repo = Get.find<SurveyDetailsRepo>();
  final SurveyResponseModel survey = Get.arguments;
  RxList<QuestionResponse> responses = RxList();
  SurveyDetailsController();
  @override
  void onInit() {
    responses = List<QuestionResponse>.generate(survey.questions?.length ?? 0,
        (index) => QuestionResponse(answer: null, questionIndex: index)).obs;
    super.onInit();
  }

  // login() async {
  //   if (!formKey.currentState!.validate()) {
  //     return;
  //   }

  //   try {
  //     showLoadingOverlay();
  //     final loginRequestModel = LoginRequestModel(
  //         phone: phoneController.text, password: passwordController.text);
  //     final UserResponseModel userResponseModel =
  //         await _repo.login(loginRequestModel);
  //     print(userResponseModel.data.id);
  //     if (userResponseModel.data.isVerified != true) {
  //       Get.toNamed(AppRoutes.successs, arguments: () {
  //         Get.back();
  //       });
  //     } else {
  //       localStorage.setToken(userResponseModel.token!);
  //       DioClient.login(userResponseModel.token!);
  //       Get.offAndToNamed(AppRoutes.homeLayoutScreen);
  //     }
  //   } catch (e) {
  //     final exceptionMessage =
  //         (e is MyCustomException) ? e.message : AppConstants.error;
  //     showErrorDialog(exceptionMessage);
  //   } finally {
  //     hideLoadingOverlay();
  //   }
  // }

  addResponse(int questionIndex, String answer) {
    responses[questionIndex] =
        responses[questionIndex].copyWith(answer: answer);
    update();
  }

  submitSurvey() async {
    print(responses);
    if (responses.any((e) => e.answer == null) == true) {
      showErrorDialog('برجاء اختيار الاجابات المطلوبة');
      return;
    }

    try {
      showLoadingOverlay();
      final surveyRequestModel = SurveyRequestModel(
          questionnaireId: survey.id!,
          studentId: "653e46e51dedbd286c972126",
          responses: responses);
      await _repo.submitSurvey(surveyRequestModel);
      Get.back();
    } catch (e) {
      final exceptionMessage =
          (e is MyCustomException) ? e.message : AppConstants.error;
      showErrorDialog(exceptionMessage);
    } finally {
      hideLoadingOverlay();
    }
  }
}
