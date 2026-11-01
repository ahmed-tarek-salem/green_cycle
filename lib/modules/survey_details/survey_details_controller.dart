import 'package:get/get.dart';
import 'package:green_cycle/models/request_models/survey_request_model.dart';
import 'package:green_cycle/models/response_models/survey_response_model.dart';
import 'package:green_cycle/modules/home_layout/home_layout_controller.dart';
import 'package:green_cycle/modules/survey_details/surver_details_repo.dart';
import 'package:green_cycle/modules/surveys/survey_controller.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/global/points_label.dart';
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

  void addResponse(int questionIndex, String answer) {
    responses[questionIndex] =
        responses[questionIndex].copyWith(answer: answer);
    update();
  }

  /// Written answers. Blank text counts as unanswered, so the "answer every
  /// question" check still catches it.
  void setTextResponse(int questionIndex, String text) {
    final trimmed = text.trim();
    responses[questionIndex] = QuestionResponse(
      questionIndex: questionIndex,
      answer: trimmed.isEmpty ? null : trimmed,
    );
  }

  Future<void> submitSurvey() async {
    if (responses.any((e) => e.answer == null) == true) {
      showErrorDialog('برجاء اختيار الاجابات المطلوبة');
      return;
    }

    // The user is only set once the home screen finished loading it.
    // TODO: remove this lookup with SurveyRequestModel.studentId once the
    // backend reads the student from the token (https://trello.com/c/5DimQIAa).
    final home = Get.find<HomeLayoutController>();
    final studentId = home.isLoading || home.isError ? null : home.user.id;
    if (studentId == null) {
      showErrorDialog(AppConstants.error);
      return;
    }

    try {
      showLoadingOverlay();
      final surveyRequestModel = SurveyRequestModel(
          questionnaireId: survey.id!,
          studentId: studentId,
          responses: responses);
      await _repo.submitSurvey(surveyRequestModel);
      _markAnsweredInList();
      final reward = survey.rewardPoints > 0
          ? 'حصلت على ${pointsLabel(survey.rewardPoints)}.'
          : 'نشكرك على مشاركتك برأيك.';
      showSuccessDialog(
        'تم إرسال إجابتك بنجاح',
        reward,
        onTap: () {
          Get.back();
          Get.back();
        },
      );
    } catch (e) {
      if (e is MyCustomException) {
        showErrorDialog(surveySubmitErrorMessage(e.message, code: e.code));
        if (e.code == 'ALREADY_ANSWERED') _markAnsweredInList();
      } else {
        showErrorDialog(AppConstants.error);
      }
    } finally {
      hideLoadingOverlay();
    }
  }

  /// Updates the list behind this screen so it shows the survey as answered
  /// without another request.
  void _markAnsweredInList() {
    if (!Get.isRegistered<SurveyController>()) return;
    Get.find<SurveyController>().markAnswered(survey.id);
  }
}
