import 'package:dio/dio.dart';
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
}
