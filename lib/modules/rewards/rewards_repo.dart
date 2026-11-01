import 'package:dio/dio.dart';
import 'package:green_cycle/models/response_models/my_rewards_response_model.dart';
import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class RewardsRepo {
  /// The catalog is public, so it needs no token.
  Future<RewardsCatalogResponseModel> getCatalog() async {
    try {
      final response = await DioClient.publicDio.get(AppEndpoints.rewards);
      return RewardsCatalogResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  /// The signed-in student's progress, including which activities they
  /// already have a request under review for.
  Future<MyRewardsResponseModel> getMyRewards() async {
    try {
      final response = await DioClient.privateDio.get(AppEndpoints.rewardsMe);
      return MyRewardsResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }
}
