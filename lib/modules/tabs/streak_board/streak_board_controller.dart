import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/current_user_rank_response_model.dart';
import 'package:green_cycle/models/response_models/leaderboard_response_model.dart';
import 'package:green_cycle/modules/tabs/streak_board/streak_board_repo.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class StreakBoardController extends BaseController {
  final _repo = Get.find<StreakBoardRepo>();

  final RxList<LeaderboardEntry> topUsers = <LeaderboardEntry>[].obs;
  final Rxn<CurrentUserRankResponseModel> currentUserRank = Rxn();

  @override
  void onInit() {
    if (isInit) {
      loadLeaderboard();
      isInit = false;
    }
    super.onInit();
  }

  Future<void> loadLeaderboard() async {
    try {
      setLoading = true;
      final results = await Future.wait([
        _repo.getLeaderboard(page: 1, limit: 3),
        _repo.getCurrentUserRank(),
      ]);
      topUsers.assignAll(
          (results[0] as LeaderboardResponseModel).leaderboard);
      currentUserRank.value = results[1] as CurrentUserRankResponseModel;
      setError = false;
      update();
    } catch (e) {
      setError = true;
      final exceptionMessage =
          (e is MyCustomException) ? e.message : AppConstants.error;
      showErrorDialog(exceptionMessage);
    } finally {
      setLoading = false;
    }
  }
}
