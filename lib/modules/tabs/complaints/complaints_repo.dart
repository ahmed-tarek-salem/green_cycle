import 'package:dio/dio.dart' as dio;
import 'package:green_cycle/models/request_models/feedback_request_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class ComplaintsRepo {
  Future<void> submitFeedback(FeedbackRequestModel request) async {
    try {
      await DioClient.privateDio.post(
        AppEndpoints.feedback,
        data: dio.FormData.fromMap(request.toMap()),
      );
    } on dio.DioException catch (e) {
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
