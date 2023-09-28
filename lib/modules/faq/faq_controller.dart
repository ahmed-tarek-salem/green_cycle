import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/question_response_model.dart';
import 'package:green_cycle/modules/faq/faq_repo.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class FaqController extends BaseController {
  final _repo = FaqRepo();
  final RxList<QuestionResponseModel> questions = RxList();

  @override
  void onInit() {
    getFaqs();
    print('object');
    super.onInit();
  }

  Future<void> getFaqs() async {
    try {
      setLoading = true;
      final data = await _repo.getFaqs();
      questions.addAll(data.questions);
      print(questions.length);
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
