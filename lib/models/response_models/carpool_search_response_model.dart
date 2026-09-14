import 'package:green_cycle/models/response_models/carpool_offer_response_model.dart';

class CarpoolSearchResult {
  final String id;
  final CarpoolDriverSummary driver;
  final String destinationNameEn;
  final String destinationNameAr;
  final List<Checkpoint> checkpoints;
  final WeeklyScheduleEntry? scheduleForDay;
  final List<WeeklyScheduleEntry> weeklySchedule;
  final String? notes;

  CarpoolSearchResult({
    required this.id,
    required this.driver,
    required this.destinationNameEn,
    required this.destinationNameAr,
    required this.checkpoints,
    required this.scheduleForDay,
    required this.weeklySchedule,
    this.notes,
  });

  factory CarpoolSearchResult.fromMap(Map<String, dynamic> map, {String? day}) {
    return CarpoolSearchResult(
      id: map['_id'] ?? '',
      driver: CarpoolDriverSummary.fromMap(
          (map['driver'] as Map<String, dynamic>?) ?? const {}),
      destinationNameEn: map['destinationNameEn'] ?? '',
      destinationNameAr: map['destinationNameAr'] ?? '',
      checkpoints: parseCheckpoints(map['checkpoints'] as List?),
      scheduleForDay: _parseScheduleForDay(map['scheduleForDay'], day),
      weeklySchedule: ((map['weeklySchedule'] as List?) ?? const [])
          .map((e) => WeeklyScheduleEntry.fromMap(e as Map<String, dynamic>))
          .toList(),
      notes: map['notes'],
    );
  }

  /// The backend may return `scheduleForDay` as a single object or an array.
  static WeeklyScheduleEntry? _parseScheduleForDay(dynamic raw, String? day) {
    if (raw is Map) {
      return WeeklyScheduleEntry.fromMap(raw.cast<String, dynamic>());
    }
    if (raw is List && raw.isNotEmpty) {
      final match = raw.cast<Map>().firstWhere(
            (e) => day != null && e['dayOfWeek'] == day,
            orElse: () => raw.first as Map,
          );
      return WeeklyScheduleEntry.fromMap(match.cast<String, dynamic>());
    }
    return null;
  }
}

class SearchResponseModel {
  final List<CarpoolSearchResult> offers;

  SearchResponseModel({required this.offers});

  factory SearchResponseModel.fromMap(Map<String, dynamic> map, {String? day}) {
    final data = map['data'];
    final list = (data is Map ? data['offers'] : null) as List? ?? const [];
    return SearchResponseModel(
      offers: list
          .map((e) =>
              CarpoolSearchResult.fromMap(e as Map<String, dynamic>, day: day))
          .toList(),
    );
  }
}
