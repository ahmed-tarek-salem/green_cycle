import 'package:dio/dio.dart';
import 'package:green_cycle/models/request_models/survey_request_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class SurveyDetailsRepo {
  Future<void> submitSurvey(SurveyRequestModel data) async {
    try {
      await DioClient.privateDio
          .post(AppEndpoints.surveyResponse, data: data.toJson());
    } on DioException catch (e) {
      final body = e.response?.data;
      throw MyCustomException(
        (body is Map ? body['message'] : null) ?? e.message ?? '',
        code: body is Map ? body['code'] as String? : null,
      );
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }
}
