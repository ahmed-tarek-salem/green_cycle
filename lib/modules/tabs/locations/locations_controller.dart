import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/locations_response_model.dart';
import 'package:green_cycle/modules/tabs/locations/locations_repo.dart';
import 'package:green_cycle/theme/app_images.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/mixins/overlay_mixin.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class LocationsController extends GetxController with OverlyaysMixin {
  final _repo = LocationsRepo();
  final _selectedLocationIndex = 0.obs;
  final _seletedDoorIndex = 0.obs;
  final RxBool _isLoading = false.obs;
  Rx<LocationsResponseModel?> locationsResponseModel = Rx(null);

  @override
  void onInit() {
    getLocations();
    super.onInit();
  }

  bool get isLoading => _isLoading.value;
  set setLoading(bool value) {
    _isLoading.value = value;
    update();
  }

  Future<void> getLocations() async {
    try {
      setLoading = true;
      locationsResponseModel.value = await _repo.getLocations();
      update();
    } catch (e) {
      final exceptionMessage =
          (e is MyCustomException) ? e.message : AppConstants.error;
      showErrorDialog(exceptionMessage);
    }
  }

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
  String? getSelectedMap() {
    if (locationsResponseModel.value == null) return null;
    if (_selectedLocationIndex.value == 1) {
      return locationsResponseModel
          .value!.newBuildingMaps[_seletedDoorIndex.value].imageUrl;
    } else if (_selectedLocationIndex.value == 2) {
      return locationsResponseModel
          .value!.oldBuildingMaps[_seletedDoorIndex.value].imageUrl;
    }
    return null;
  }
}
