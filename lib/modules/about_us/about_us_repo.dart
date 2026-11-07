import 'package:dio/dio.dart';
import 'package:green_cycle/models/response_models/about_us_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class AboutUsRepo {
  Future<AboutUsResponseModel> getAboutUs() async {
    try {
      final response = await DioClient.publicDio.get(AppEndpoints.aboutUs);
      return AboutUsResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }
}
