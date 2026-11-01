import 'package:dio/dio.dart' as dio;
import 'package:green_cycle/models/request_models/activity_request_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class ActionRepo {
  /// Submits the activity for review. Returns the points the server proposes
  /// for it, or null if the response does not say.
  Future<int?> submitAction(ActivityRequestModel activityRequestModel) async {
    try {
      final response = await DioClient.privateDio.post(
        AppEndpoints.activities,
        data: dio.FormData.fromMap(activityRequestModel.toMap()),
      );
      return _proposedPoints(response.data);
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

  int? _proposedPoints(Object? body) {
    if (body is! Map) return null;
    final data = body['data'];
    if (data is! Map) return null;
    final activity = data['activity'];
    if (activity is! Map) return null;
    final points = activity['points'];
    return points is num ? points.toInt() : null;
  }
}
