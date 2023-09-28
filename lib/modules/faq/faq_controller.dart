import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/question_response_model.dart';
import 'package:green_cycle/modules/faq/faq_repo.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/mixins/overlay_mixin.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class FaqController extends GetxController with OverlyaysMixin {
  final _repo = FaqRepo();
  final RxBool _isLoading = false.obs;
  final RxBool _isError = false.obs;
  final RxList<QuestionResponseModel> questions = RxList();

  @override
  void onInit() {
    getFaqs();
    print('object');
    super.onInit();
  }

  bool get isLoading => _isLoading.value;
  set setLoading(bool value) {
    _isLoading.value = value;
    update();
  }

  bool get isError => _isLoading.value;
  set setError(bool value) {
    _isError.value = value;
    update();
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
