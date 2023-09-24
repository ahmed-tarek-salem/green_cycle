import 'package:dio/dio.dart';
import 'package:green_cycle/models/request_models/login_request_model.dart';
import 'package:green_cycle/models/response_models/user_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class LoginRepo {
  Future<UserResponseModel> login(LoginRequestModel loginRequestModel) async {
    try {
      final response = await DioClient.publicDio
          .post(AppEndpoints.login, data: loginRequestModel.toMap());
      return UserResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }
}
