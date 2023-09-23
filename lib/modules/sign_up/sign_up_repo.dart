import 'package:green_cycle/models/request_models/sign_up_request_model.dart';
import 'package:green_cycle/models/response_models/error_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class SignUpRepo {
  signUp(SignUpRequestModel signUpRequestModel) {
    Future<void> signUp(SignUpRequestModel signUpRequestModel) async {
      try {
        final response = await DioClient.privateDio
            .post(AppEndpoints.login, data: signUpRequestModel);
        if (response.statusCode == 200) {
          // Request was successful, do something with the response.
        } else {
          // Handle non-200 status codes here.
          final errorResponse = ErrorResponseModel.fromMap(response.data);
          throw MyCustomException(errorResponse.message);
        }
      } catch (e) {
        rethrow; // Rethrow the exception to handle it in the UI.
      }
    }
  }
}
