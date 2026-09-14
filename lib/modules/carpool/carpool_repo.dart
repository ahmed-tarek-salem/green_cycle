import 'package:dio/dio.dart';
import 'package:green_cycle/models/request_models/contact_driver_request_model.dart';
import 'package:green_cycle/models/request_models/setup_offer_request_model.dart';
import 'package:green_cycle/models/response_models/carpool_offer_response_model.dart';
import 'package:green_cycle/models/response_models/carpool_search_response_model.dart';
import 'package:green_cycle/models/response_models/contact_driver_response_model.dart';
import 'package:green_cycle/models/response_models/district_response_model.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class CarpoolRepo {
  List<District>? _districtsCache;

  Future<List<District>> getDistricts({bool forceRefresh = false}) async {
    if (!forceRefresh && _districtsCache != null) return _districtsCache!;
    try {
      final res = await DioClient.publicDio.get(AppEndpoints.carpoolDistricts);
      _districtsCache = DistrictsResponseModel.fromMap(res.data).districts;
      return _districtsCache!;
    } on DioException catch (e) {
      throw MyCustomException(_message(e));
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  Future<CarpoolOffer?> getMyOffer() async {
    try {
      final res = await DioClient.privateDio.get(AppEndpoints.carpoolOfferMe);
      return OfferResponseModel.fromMap(res.data).offer;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null; // no offer yet
      throw MyCustomException(_message(e));
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  Future<CarpoolOffer?> upsertOffer(SetupOfferRequest request) async {
    try {
      final res = await DioClient.privateDio
          .post(AppEndpoints.carpoolOfferMe, data: request.toMap());
      return OfferResponseModel.fromMap(res.data).offer;
    } on DioException catch (e) {
      throw MyCustomException(_message(e));
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  Future<void> deactivateOffer() async {
    try {
      await DioClient.privateDio.delete(AppEndpoints.carpoolOfferMe);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return;
      throw MyCustomException(_message(e));
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  Future<List<CarpoolSearchResult>> search({
    required String districtId,
    String? dayOfWeek,
  }) async {
    try {
      final res = await DioClient.privateDio.get(
        AppEndpoints.carpoolSearch,
        queryParameters: {
          'districtId': districtId,
          if (dayOfWeek != null) 'dayOfWeek': dayOfWeek,
        },
      );
      return SearchResponseModel.fromMap(res.data, day: dayOfWeek).offers;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw MyCustomException(_message(e));
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  Future<ContactDriverResponseModel> contact({
    required String offerId,
    required String districtId,
    required String dayOfWeek,
  }) async {
    try {
      final res = await DioClient.privateDio.post(
        AppEndpoints.carpoolContact(offerId),
        data: ContactDriverRequest(districtId: districtId, dayOfWeek: dayOfWeek)
            .toMap(),
      );
      return ContactDriverResponseModel.fromMap(res.data);
    } on DioException catch (e) {
      throw MyCustomException(_message(e));
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  String _message(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return e.message ?? AppConstants.error;
  }
}
