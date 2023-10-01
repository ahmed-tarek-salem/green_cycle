import 'package:green_cycle/models/response_models/map_image_response_model.dart';

class LocationsResponseModel {
  final List<MapImageResponseModel> oldBuildingMaps;
  final List<MapImageResponseModel> newBuildingMaps;
  final List<MapImageResponseModel> yard;

  LocationsResponseModel(
      {required this.oldBuildingMaps,
      required this.newBuildingMaps,
      required this.yard});

  factory LocationsResponseModel.fromMap(Map<String, dynamic> map) {
    return LocationsResponseModel(
      yard: List<MapImageResponseModel>.from(map['map']['yard']
          .map((mapImage) => MapImageResponseModel.fromMap(mapImage))),
      oldBuildingMaps: List<MapImageResponseModel>.from(map['map']
              ['oldBuilding']
          .map((mapImage) => MapImageResponseModel.fromMap(mapImage))),
      newBuildingMaps: List<MapImageResponseModel>.from(map['map']
              ['newBuilding']
          .map((mapImage) => MapImageResponseModel.fromMap(mapImage))),
    );
  }
}
