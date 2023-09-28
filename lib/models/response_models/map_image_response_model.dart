class MapImageResponseModel {
  final String? id;
  final String? imageUrl;
  final String? building;
  final int? floor;
  MapImageResponseModel({
    required this.id,
    required this.imageUrl,
    required this.building,
    required this.floor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'imageUrl': imageUrl,
      'building': building,
      'floor': floor,
    };
  }

  factory MapImageResponseModel.fromMap(Map<String, dynamic> map) {
    return MapImageResponseModel(
      id: map['_id'],
      imageUrl: map['imageUrl'],
      building: map['building'],
      floor: map['floor'],
    );
  }
}
