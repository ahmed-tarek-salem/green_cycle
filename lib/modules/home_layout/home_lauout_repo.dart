import 'package:dio/dio.dart';
import 'package:green_cycle/models/response_models/user_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';

import '../../utilities/network/dio_client.dart';

class HomeLayoutRepo {
  Future<UserResponseModel> getUser() async {
    try {
      final response = await DioClient.privateDio.get(AppEndpoints.user);
      return UserResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      print(e);
      throw MyCustomException(e.toString());
    }
  }
}
