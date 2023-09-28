import 'package:get/get.dart';
import 'package:green_cycle/utilities/mixins/overlay_mixin.dart';

class BaseController extends GetxController with OverlyaysMixin {
  final RxBool _isLoading = false.obs;
  final RxBool _isError = false.obs;
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
}
