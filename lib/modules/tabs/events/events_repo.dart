import 'package:dio/dio.dart';
import 'package:green_cycle/models/response_models/event_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class EventsRepo {
  Future<EventesResponseModel> getEvents() async {
    try {
      final response = await DioClient.privateDio.get(AppEndpoints.events);
      return EventesResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      print(e);
      throw MyCustomException(e.toString());
    }
  }
}
