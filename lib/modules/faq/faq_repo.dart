import 'package:dio/dio.dart';
import 'package:green_cycle/models/response_models/faq_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class FaqRepo {
  Future<FaqResponseModel> getFaqs() async {
    try {
      final response = await DioClient.privateDio.get(AppEndpoints.faqs);
      return FaqResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      print(e);
      throw MyCustomException(e.toString());
    }
  }
}
