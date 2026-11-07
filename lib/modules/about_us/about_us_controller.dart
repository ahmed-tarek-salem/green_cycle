import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/about_us_response_model.dart';
import 'package:green_cycle/modules/about_us/about_us_repo.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';

class AboutUsController extends BaseController {
  final _repo = Get.find<AboutUsRepo>();

  /// Stays null if loading fails, so the page still shows its static part.
  AboutUsResponseModel? aboutUs;

  @override
  void onInit() {
    loadAboutUs();
    super.onInit();
  }

  Future<void> loadAboutUs() async {
    try {
      setLoading = true;
      aboutUs = await _repo.getAboutUs();
      setError = false;
    } catch (_) {
      setError = true;
    } finally {
      setLoading = false;
      update();
    }
  }
}
