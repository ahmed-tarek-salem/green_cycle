import 'package:dio/dio.dart';
import 'package:green_cycle/models/request_models/survey_request_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class SurveyDetailsRepo {
  Future<void> submitSurvey(SurveyRequestModel data) async {
    try {
      final response = await DioClient.privateDio
          .post(AppEndpoints.surveyResponse, data: data.toJson());
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }
}
