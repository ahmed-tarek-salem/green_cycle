import 'package:dio/dio.dart';
import 'package:green_cycle/models/response_models/my_activities_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class MyActivitiesRepo {
  Future<MyActivitiesResponseModel> getMyActivities({required int page}) async {
    try {
      final response = await DioClient.privateDio.get(
        AppEndpoints.myActivities,
        queryParameters: {'page': page, 'limit': 20},
      );
      return MyActivitiesResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }
}
