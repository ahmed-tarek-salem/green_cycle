import 'package:green_cycle/models/response_models/district_response_model.dart';

class WeeklyScheduleEntry {
  final String dayOfWeek;
  final String arrivalTime; // "HH:MM"
  final bool active;

  const WeeklyScheduleEntry({
    required this.dayOfWeek,
    required this.arrivalTime,
    this.active = true,
  });

  factory WeeklyScheduleEntry.fromMap(Map<String, dynamic> map) =>
      WeeklyScheduleEntry(
        dayOfWeek: map['dayOfWeek'] ?? '',
        arrivalTime: map['arrivalTime'] ?? '',
        active: map['active'] ?? true,
      );

  Map<String, dynamic> toMap() =>
      {'dayOfWeek': dayOfWeek, 'arrivalTime': arrivalTime, 'active': active};
}

class Checkpoint {
  final District district;
  final int order;

  const Checkpoint({required this.district, required this.order});

  factory Checkpoint.fromMap(Map<String, dynamic> map) => Checkpoint(
        district: District.fromMap(
            (map['district'] as Map<String, dynamic>?) ?? const {}),
        order: map['order'] ?? 0,
      );
}

class CarpoolDriverSummary {
  final String id;
  final String name;
  final String avatar;
  final String gender;
  final int? phone;

  const CarpoolDriverSummary({
    required this.id,
    required this.name,
    required this.avatar,
    required this.gender,
    this.phone,
  });

  factory CarpoolDriverSummary.fromMap(Map<String, dynamic> map) =>
      CarpoolDriverSummary(
        id: map['_id'] ?? '',
        name: map['name'] ?? '',
        avatar: map['avatar'] ?? '',
        gender: map['gender'] ?? '',
        phone: map['phone'],
      );
}

/// Sorts a raw checkpoints list by `order` and maps to [Checkpoint].
List<Checkpoint> parseCheckpoints(List? raw) {
  final list = (raw ?? const [])
      .map((e) => Checkpoint.fromMap(e as Map<String, dynamic>))
      .toList()
    ..sort((a, b) => a.order.compareTo(b.order));
  return list;
}

class CarpoolOffer {
  final String id;
  final CarpoolDriverSummary driver;
  final String destinationNameEn;
  final String destinationNameAr;
  final List<WeeklyScheduleEntry> weeklySchedule;
  final List<Checkpoint> checkpoints;
  final bool isActive;
  final String? notes;

  CarpoolOffer({
    required this.id,
    required this.driver,
    required this.destinationNameEn,
    required this.destinationNameAr,
    required this.weeklySchedule,
    required this.checkpoints,
    required this.isActive,
    this.notes,
  });

  factory CarpoolOffer.fromMap(Map<String, dynamic> map) => CarpoolOffer(
        id: map['_id'] ?? '',
        driver: CarpoolDriverSummary.fromMap(
            (map['driver'] as Map<String, dynamic>?) ?? const {}),
        destinationNameEn: map['destinationNameEn'] ?? '',
        destinationNameAr: map['destinationNameAr'] ?? '',
        weeklySchedule: ((map['weeklySchedule'] as List?) ?? const [])
            .map((e) => WeeklyScheduleEntry.fromMap(e as Map<String, dynamic>))
            .toList(),
        checkpoints: parseCheckpoints(map['checkpoints'] as List?),
        isActive: map['isActive'] ?? true,
        notes: map['notes'],
      );
}

class OfferResponseModel {
  final CarpoolOffer? offer;

  OfferResponseModel({required this.offer});

  factory OfferResponseModel.fromMap(Map<String, dynamic> map) {
    final data = map['data'];
    final raw = data is Map ? data['offer'] : null;
    return OfferResponseModel(
      offer: raw == null
          ? null
          : CarpoolOffer.fromMap(raw as Map<String, dynamic>),
    );
  }
}
