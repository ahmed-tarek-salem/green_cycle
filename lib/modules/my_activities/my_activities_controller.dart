import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/my_activities_response_model.dart';
import 'package:green_cycle/modules/my_activities/my_activities_repo.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

/// The student's own requests and where each one stands: under review,
/// accepted with the points given, or rejected with the reason.
class MyActivitiesController extends BaseController {
  final _repo = Get.find<MyActivitiesRepo>();
  final RxList<MyActivity> activities = <MyActivity>[].obs;
  final RxBool loadingMore = false.obs;
  int _page = 1;
  bool _hasMore = false;

  @override
  void onInit() {
    loadFirstPage();
    super.onInit();
  }

  Future<void> loadFirstPage() async {
    try {
      setLoading = true;
      await _load(page: 1);
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
  Future<void> refreshList() async {
    try {
      await _load(page: 1);
    } catch (e) {
      final exceptionMessage =
          (e is MyCustomException) ? e.message : AppConstants.error;
      showErrorDialog(exceptionMessage);
    }
  }

  /// Called when the list nears its end. Failures are quiet: the student can
  /// scroll again to retry.
  Future<void> loadMore() async {
    if (!_hasMore || loadingMore.value) return;
    loadingMore.value = true;
    try {
      await _load(page: _page + 1);
    } catch (_) {
    } finally {
      loadingMore.value = false;
    }
  }

  Future<void> _load({required int page}) async {
    final result = await _repo.getMyActivities(page: page);
    if (page == 1) {
      activities.assignAll(result.activities);
    } else {
      activities.addAll(result.activities);
    }
    _page = result.page;
    _hasMore = result.hasMore;
    update();
  }
}
