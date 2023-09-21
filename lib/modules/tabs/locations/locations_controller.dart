import 'package:get/get.dart';
import 'package:green_cycle/theme/app_images.dart';

class LocationsController extends GetxController {
  final _selectedLocationIndex = 0.obs;
  final _seletedDoorIndex = 0.obs;

  int get selectedLocationIndex => _selectedLocationIndex.value;
  int get selectedDoorIndex => _seletedDoorIndex.value;

  set selectedLocationIndex(int index) {
    _selectedLocationIndex.value = index;
    update();
  }

  set selectedDoorIndex(int index) {
    _seletedDoorIndex.value = index;
    update();
  }

  final List<String> loactionImagePaths = [
    AppImages.saha,
    AppImages.newThird,
    AppImages.newThird,
  ];
}
