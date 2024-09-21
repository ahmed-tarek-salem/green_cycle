import 'package:dio/dio.dart';
import 'package:green_cycle/models/response_models/survey_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class SurveyRepo {
  Future<List<SurveyResponseModel>> getSurveys() async {
    try {
      final response = await DioClient.privateDio.get(AppEndpoints.surveys);
      print(response.data);
      return List.from(
          response.data["data"].map((x) => SurveyResponseModel.fromJson(x)));
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }
}
