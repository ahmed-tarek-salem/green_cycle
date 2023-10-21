import 'package:green_cycle/models/request_models/activity_request_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';
import 'package:dio/dio.dart' as dio;

class ActionRepo {
  Future<bool> submitAction(ActivityRequestModel activityRequestModel) async {
    try {
      print(activityRequestModel.toMap());
      final response = await DioClient.privateDio.post(AppEndpoints.activities,
          data: dio.FormData.fromMap(activityRequestModel.toMap()));
      print(response.data);
      return true;
    } on dio.DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }
}
