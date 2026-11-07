import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/event_response_model.dart';

void main() {
  test('reads the event time in the phone time zone, not UTC', () {
    final event = Event.fromMap({
      '_id': 'e1',
      'name': 'يوم تنظيف',
      'date': '2026-11-05T08:00:00.000Z',
    });
    expect(event.date!.isUtc, isFalse);
    expect(event.date, DateTime.utc(2026, 11, 5, 8).toLocal());
  });

  test('an event without a date has none', () {
    final event = Event.fromMap({'_id': 'e2', 'name': 'x'});
    expect(event.date, isNull);
  });

  test('reads the optional event photo', () {
    expect(Event.fromMap({'_id': 'e3', 'image': 'https://x/e.png'}).image,
        'https://x/e.png');
    expect(Event.fromMap({'_id': 'e4', 'image': '  '}).image, isNull);
    expect(Event.fromMap({'_id': 'e5'}).image, isNull);
  });
}
