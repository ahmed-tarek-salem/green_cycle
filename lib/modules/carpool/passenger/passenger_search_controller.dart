import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/carpool_search_response_model.dart';
import 'package:green_cycle/models/response_models/district_response_model.dart';
import 'package:green_cycle/modules/carpool/carpool_controller.dart';
import 'package:green_cycle/modules/carpool/carpool_repo.dart';
import 'package:green_cycle/modules/carpool/carpool_utils.dart';
import 'package:green_cycle/modules/carpool/whatsapp_launcher.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class PassengerSearchController extends BaseController {
  final _repo = Get.find<CarpoolRepo>();

  List<District> get districts => Get.find<CarpoolController>().districts;
  final Rxn<District> selectedDistrict = Rxn();
  final RxString selectedDay = CarpoolDays.all.first.obs;

  final RxList<CarpoolSearchResult> results = <CarpoolSearchResult>[].obs;
  final RxBool hasSearched = false.obs;
  final RxBool searching = false.obs;

  void selectDistrict(District d) {
    selectedDistrict.value = d;
    results.clear();
    hasSearched.value = false;
    update();
  }

  void selectDay(String day) {
    selectedDay.value = day;
    results.clear();
    hasSearched.value = false;
    update();
  }

  Future<void> runSearch() async {
    if (searching.value) return;
    if (selectedDistrict.value == null) return;
    try {
      searching.value = true;
      update();
      final r = await _repo.search(
        districtId: selectedDistrict.value!.id,
        dayOfWeek: selectedDay.value,
      );
      results.assignAll(r);
      hasSearched.value = true;
    } catch (e) {
      showErrorDialog(e is MyCustomException ? e.message : AppConstants.error);
    } finally {
      searching.value = false;
      update();
    }
  }

  Future<void> contactDriver(CarpoolSearchResult offer) async {
    try {
      showLoadingOverlay();
      final res = await _repo.contact(
        offerId: offer.id,
        districtId: selectedDistrict.value!.id,
        dayOfWeek: selectedDay.value,
      );
      hideLoadingOverlay();
      final opened = await WhatsappLauncher.open(
        res.driver.whatsappUrl,
        message: _prefilledMessage(),
      );
      if (!opened) {
        Get.snackbar('واتساب', 'تعذّر فتح واتساب على هذا الجهاز',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      // Expected case: 404 = driver deactivated the offer between search and
      // contact. The repo throws an untyped MyCustomException, so we can't
      // distinguish it from a transient error; re-running search self-heals.
      hideLoadingOverlay();
      Get.snackbar('غير متاح', 'لم يعد هذا العرض متاحاً، جرّب عرضاً آخر',
          snackPosition: SnackPosition.BOTTOM);
      runSearch();
    }
  }

  String _prefilledMessage() =>
      'مرحباً، وجدت عرضك على Green Cycle وأحتاج مشاركة سيارة يوم ${CarpoolDays.label(selectedDay.value)}';
}
