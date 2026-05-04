import 'package:dio/dio.dart';
import 'package:green_cycle/models/response_models/current_user_rank_response_model.dart';
import 'package:green_cycle/models/response_models/leaderboard_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class StreakBoardRepo {
  Future<LeaderboardResponseModel> getLeaderboard({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await DioClient.publicDio.get(
        AppEndpoints.leaderboard,
        queryParameters: {'page': page, 'limit': limit},
      );
      return LeaderboardResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  Future<CurrentUserRankResponseModel> getCurrentUserRank() async {
    try {
      final response =
          await DioClient.privateDio.get(AppEndpoints.leaderboardMe);
      return CurrentUserRankResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }
}
