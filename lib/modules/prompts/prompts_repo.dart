import 'package:dio/dio.dart';
import 'package:green_cycle/models/response_models/prompts_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class TripConfirmResult {
  final bool awaitingOther;
  final int points;

  const TripConfirmResult({required this.awaitingOther, required this.points});
}

class PromptsRepo {
  Future<List<AppPrompt>> getPrompts() async {
    try {
      final response = await DioClient.privateDio.get(AppEndpoints.myPrompts);
      return parsePrompts(response.data);
    } on DioException catch (e) {
      throw _exception(e);
    }
  }

  Future<void> markSeen(String id) async {
    try {
      await DioClient.privateDio.post(AppEndpoints.promptSeen(id));
    } on DioException catch (e) {
      throw _exception(e);
    }
  }

  Future<TripConfirmResult> confirmTrip(String tripId, {required bool rode}) async {
    try {
      final response = await DioClient.privateDio.post(
        AppEndpoints.carpoolTripConfirm(tripId),
        data: {'rode': rode},
      );
      final data = response.data['data'] as Map<String, dynamic>? ?? const {};
      return TripConfirmResult(
        awaitingOther: data['awaitingOtherParty'] == true,
        points: (data['pointsAwarded'] as num?)?.toInt() ?? 0,
      );
    } on DioException catch (e) {
      throw _exception(e);
    }
  }

  MyCustomException _exception(DioException e) {
    final body = e.response?.data;
    return MyCustomException(
      (body is Map ? body['message'] : null) ?? e.message ?? '',
      code: body is Map ? body['code'] as String? : null,
    );
  }
}
