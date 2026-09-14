class District {
  final String id;
  final String nameEn;
  final String nameAr;

  const District(
      {required this.id, required this.nameEn, required this.nameAr});

  factory District.fromMap(Map<String, dynamic> map) => District(
        id: map['_id'] ?? '',
        nameEn: map['nameEn'] ?? '',
        nameAr: map['nameAr'] ?? '',
      );
}

class DistrictsResponseModel {
  final List<District> districts;

  DistrictsResponseModel({required this.districts});

  factory DistrictsResponseModel.fromMap(Map<String, dynamic> map) {
    final data = map['data'];
    final list = (data is Map ? data['districts'] : null) as List? ?? const [];
    return DistrictsResponseModel(
      districts:
          list.map((e) => District.fromMap(e as Map<String, dynamic>)).toList(),
    );
  }
}
