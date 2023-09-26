import 'package:dio/dio.dart';
import 'package:green_cycle/models/request_models/sign_up_request_model.dart';
import 'package:green_cycle/models/response_models/user_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';
import 'package:dio/dio.dart' as dio;

class SignUpRepo {
  Future<UserResponseModel> signUp(
      SignUpRequestModel signUpRequestModel) async {
    try {
      final response = await DioClient.publicDio.post(AppEndpoints.signup,
          data: dio.FormData.fromMap(signUpRequestModel.toMap()));
      return UserResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  verifyOtp() async {
    try {
      final response = await DioClient.privateDio
          .post(AppEndpoints.veifyOtp, data: {'OTPVerified': true});
      return UserResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }
}
