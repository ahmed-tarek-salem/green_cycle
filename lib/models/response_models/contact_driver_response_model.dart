class ContactDriver {
  final String id;
  final String name;
  final int? phone;
  final String whatsappUrl;

  ContactDriver({
    required this.id,
    required this.name,
    required this.phone,
    required this.whatsappUrl,
  });

  factory ContactDriver.fromMap(Map<String, dynamic> map) => ContactDriver(
        id: map['_id'] ?? '',
        name: map['name'] ?? '',
        phone: map['phone'],
        whatsappUrl: map['whatsappUrl'] ?? '',
      );
}

class CarpoolTrip {
  final String id;
  final String dayOfWeek;
  final String status;

  CarpoolTrip(
      {required this.id, required this.dayOfWeek, required this.status});

  factory CarpoolTrip.fromMap(Map<String, dynamic> map) => CarpoolTrip(
        id: map['_id'] ?? '',
        dayOfWeek: map['dayOfWeek'] ?? '',
        status: map['status'] ?? '',
      );
}

class ContactDriverResponseModel {
  final ContactDriver driver;
  final CarpoolTrip trip;

  ContactDriverResponseModel({required this.driver, required this.trip});

  factory ContactDriverResponseModel.fromMap(Map<String, dynamic> map) {
    final rawData = map['data'];
    final data = rawData is Map ? rawData : const {};
    final rawDriver = data['driver'];
    final rawTrip = data['trip'];
    return ContactDriverResponseModel(
      driver: ContactDriver.fromMap(
          rawDriver is Map ? rawDriver.cast<String, dynamic>() : const {}),
      trip: CarpoolTrip.fromMap(
          rawTrip is Map ? rawTrip.cast<String, dynamic>() : const {}),
    );
  }
}
