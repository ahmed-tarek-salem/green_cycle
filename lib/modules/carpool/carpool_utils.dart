import 'package:flutter/material.dart';

/// Default carpool destination (Faculty of Pharmacy, Alexandria University).
const String kCarpoolDestinationAr = 'كلية الصيدلة - جامعة الإسكندرية';
const String kCarpoolDestinationEn =
    'Faculty of Pharmacy, Alexandria University';

class CarpoolDays {
  static const List<String> all = [
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
  ];

  static const Map<String, String> _ar = {
    'sunday': 'الأحد',
    'monday': 'الإثنين',
    'tuesday': 'الثلاثاء',
    'wednesday': 'الأربعاء',
    'thursday': 'الخميس',
    'friday': 'الجمعة',
    'saturday': 'السبت',
  };

  static String label(String day) => _ar[day] ?? day;
}

/// 24-hour, zero-padded "HH:MM" (e.g. 08:00, 14:30).
String formatTimeOfDay(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

/// Parse an "HH:MM" string back into a TimeOfDay (for edit prefill). Returns
/// 08:00 if the string is malformed.
TimeOfDay parseHHmm(String value) {
  final parts = value.split(':');
  if (parts.length != 2) return const TimeOfDay(hour: 8, minute: 0);
  final h = int.tryParse(parts[0]) ?? 8;
  final m = int.tryParse(parts[1]) ?? 0;
  return TimeOfDay(hour: h.clamp(0, 23), minute: m.clamp(0, 59));
}
