import 'package:dio/dio.dart';
import 'package:green_cycle/models/response_models/locations_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class LocationsRepo {
  Future<LocationsResponseModel> getLocations() async {
    try {
      final response = await DioClient.privateDio.get(AppEndpoints.locations);
      return LocationsResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }
}
