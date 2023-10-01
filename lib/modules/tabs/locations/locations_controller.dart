import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/locations_response_model.dart';
import 'package:green_cycle/modules/tabs/locations/locations_repo.dart';
import 'package:green_cycle/theme/app_images.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class LocationsController extends BaseController {
  final _repo = LocationsRepo();
  final _selectedLocationIndex = 0.obs;
  final _seletedDoorIndex = 0.obs;
  Rx<LocationsResponseModel?> locationsResponseModel = Rx(null);

  @override
  void onInit() {
    if (locationsResponseModel.value == null) getLocations();
    super.onInit();
  }

  Future<void> getLocations() async {
    try {
      setLoading = true;
      locationsResponseModel.value = await _repo.getLocations();
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

  String? getSelectedMap() {
    if (locationsResponseModel.value == null) return null;
    if (_selectedLocationIndex.value == 0) {
      return locationsResponseModel.value!.yard[0].imageUrl;
    }
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
