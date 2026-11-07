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
