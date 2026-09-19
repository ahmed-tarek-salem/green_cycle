import 'package:dio/dio.dart';
import 'package:green_cycle/models/response_models/app_settings_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class AppUpdateRepo {
  /// The backend compares [currentVersion] (`x.y.z`) against its own min and
  /// latest versions and answers with the `forceUpdate` / `updateAvailable`
  /// flags, so the app never compares versions itself.
  Future<AppSettingsResponseModel> getAppSettings(String currentVersion) async {
    try {
      final response = await DioClient.publicDio.get(
        AppEndpoints.appSettings,
        queryParameters: {'currentVersion': currentVersion},
      );
      return AppSettingsResponseModel.fromMap(response.data);
    } on DioException catch (e) {
      throw MyCustomException(e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }
}
