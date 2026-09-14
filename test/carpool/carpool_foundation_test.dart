import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/district_response_model.dart';
import 'package:green_cycle/modules/carpool/carpool_utils.dart';
import 'package:green_cycle/modules/carpool/whatsapp_launcher.dart';

void main() {
  test('DistrictsResponseModel parses the districts envelope', () {
    final model = DistrictsResponseModel.fromMap({
      'status': 'success',
      'results': 2,
      'data': {
        'districts': [
          {'_id': 'a1', 'nameEn': 'Smouha', 'nameAr': 'سموحة'},
          {'_id': 'a2', 'nameEn': 'Sidi Bishr', 'nameAr': 'سيدي بشر'},
        ]
      }
    });
    expect(model.districts.length, 2);
    expect(model.districts.first.id, 'a1');
    expect(model.districts.first.nameAr, 'سموحة');
  });

  test('DistrictsResponseModel tolerates a missing districts list', () {
    expect(DistrictsResponseModel.fromMap({'data': {}}).districts, isEmpty);
  });

  test('CarpoolDays maps API values to Arabic labels', () {
    expect(CarpoolDays.all.length, 7);
    expect(CarpoolDays.label('sunday'), 'الأحد');
    expect(CarpoolDays.label('friday'), 'الجمعة');
    expect(CarpoolDays.label('unknown'), 'unknown');
  });

  test('formatTimeOfDay zero-pads to HH:MM', () {
    expect(formatTimeOfDay(const TimeOfDay(hour: 8, minute: 0)), '08:00');
    expect(formatTimeOfDay(const TimeOfDay(hour: 14, minute: 30)), '14:30');
  });

  test('parseHHmm parses valid, malformed, and out-of-range strings', () {
    final valid = parseHHmm('14:30');
    expect(valid.hour, 14);
    expect(valid.minute, 30);

    expect(parseHHmm('abc'), const TimeOfDay(hour: 8, minute: 0));
    expect(parseHHmm('8'), const TimeOfDay(hour: 8, minute: 0));
    expect(parseHHmm('25:70'), const TimeOfDay(hour: 23, minute: 59));
  });

  test('WhatsappLauncher.buildUri appends an encoded text param', () {
    final plain = WhatsappLauncher.buildUri('https://wa.me/201012345678');
    expect(plain.toString(), 'https://wa.me/201012345678');

    final withMsg = WhatsappLauncher.buildUri('https://wa.me/201012345678',
        message: 'مرحبا');
    expect(withMsg.toString(), contains('wa.me/201012345678?text='));
    expect(withMsg.queryParameters['text'], 'مرحبا');
  });

  test('WhatsappLauncher.buildUri uses & when a query string already exists',
      () {
    final withMsg =
        WhatsappLauncher.buildUri('https://wa.me/2010?foo=1', message: 'hi');
    expect(withMsg.toString(), contains('&text='));
    expect(withMsg.queryParameters['text'], 'hi');
    expect(withMsg.queryParameters['foo'], '1');
  });
}
