import 'package:green_cycle/models/response_models/map_image_response_model.dart';

class LocationsResponseModel {
  final List<MapImageResponseModel> oldBuildingMaps;
  final List<MapImageResponseModel> newBuildingMaps;

  LocationsResponseModel(
      {required this.oldBuildingMaps, required this.newBuildingMaps});

  factory LocationsResponseModel.fromMap(Map<String, dynamic> map) {
    return LocationsResponseModel(
      oldBuildingMaps: map['map']['oldBuilding']
          .map((mapImage) => MapImageResponseModel.fromMap(mapImage))
          .toList(),
      newBuildingMaps: map['map']['newBuilding']
          .map((mapImage) => MapImageResponseModel.fromMap(mapImage))
          .toList(),
    );
  }
}
