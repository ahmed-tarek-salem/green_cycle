import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';
import 'package:green_cycle/modules/home_layout/home_layout_controller.dart';
import 'package:green_cycle/modules/rewards/rewards_repo.dart';
import 'package:green_cycle/modules/rewards/widgets/rewards_catalog_view.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class RewardsController extends BaseController {
  final _repo = Get.find<RewardsRepo>();
  final Rxn<RewardsCatalogResponseModel> catalog = Rxn();

  /// Tab to open on, passed as the route argument.
  final int initialTab = Get.arguments is int
      ? Get.arguments as int
      : RewardsCatalogView.activitiesTab;

  @override
  void onInit() {
    loadCatalog();
    super.onInit();
  }

  /// The student's balance, used to mark their level. Zero until the home
  /// screen has loaded the user.
  int get totalPoints {
    if (!Get.isRegistered<HomeLayoutController>()) return 0;
    final home = Get.find<HomeLayoutController>();
    final fromRewards = home.rewards.value?.totalPoints;
    if (fromRewards != null) return fromRewards;
    if (home.isLoading || home.isError) return 0;
    return home.user.totalPoints ?? 0;
  }

  Future<void> loadCatalog() async {
    try {
      setLoading = true;
      catalog.value = await _repo.getCatalog();
      setError = false;
    } catch (e) {
      setError = true;
      final exceptionMessage =
          (e is MyCustomException) ? e.message : AppConstants.error;
      showErrorDialog(exceptionMessage);
    } finally {
      setLoading = false;
    }
  }

  /// Pull to refresh. Keeps the current list on screen while it reloads.
  Future<void> refreshCatalog() async {
    try {
      catalog.value = await _repo.getCatalog();
      update();
    } catch (e) {
      final exceptionMessage =
          (e is MyCustomException) ? e.message : AppConstants.error;
      showErrorDialog(exceptionMessage);
    }
  }
}
