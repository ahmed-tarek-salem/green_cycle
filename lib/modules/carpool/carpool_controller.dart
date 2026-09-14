import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/carpool_offer_response_model.dart';
import 'package:green_cycle/models/response_models/district_response_model.dart';
import 'package:green_cycle/modules/carpool/carpool_repo.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class CarpoolController extends BaseController {
  final _repo = Get.find<CarpoolRepo>();

  final RxList<District> districts = <District>[].obs;
  final Rxn<CarpoolOffer> myOffer = Rxn();

  bool get hasActiveOffer => myOffer.value?.isActive == true;

  @override
  void onInit() {
    if (isInit) {
      load();
      isInit = false;
    }
    super.onInit();
  }

  Future<void> load() async {
    try {
      setLoading = true;
      final results = await Future.wait([
        _repo.getDistricts(),
        _repo.getMyOffer(),
      ]);
      districts.assignAll(results[0] as List<District>);
      myOffer.value = results[1] as CarpoolOffer?;
      setError = false;
      update();
    } catch (e) {
      setError = true;
      showErrorDialog(e is MyCustomException ? e.message : AppConstants.error);
    } finally {
      setLoading = false;
    }
  }

  Future<void> refreshOffer() async {
    try {
      myOffer.value = await _repo.getMyOffer();
      update();
    } catch (_) {}
  }

  /// Update local offer state directly (e.g. from a create/update response).
  void setOffer(CarpoolOffer? offer) {
    myOffer.value = offer;
    update();
  }

  Future<void> deactivate() async {
    try {
      showLoadingOverlay();
      await _repo.deactivateOffer();
      myOffer.value = null;
      update();
      hideLoadingOverlay();
      Get.back(); // back to carpool home
      Get.snackbar('تم', 'تم إيقاف عرضك', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      hideLoadingOverlay();
      showErrorDialog(e is MyCustomException ? e.message : AppConstants.error);
    }
  }
}
