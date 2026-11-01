import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/prompts_response_model.dart';

void main() {
  final prompts = parsePrompts({
    'data': {
      'prompts': [
        {
          'id': 't9',
          'type': 'carpool_confirm',
          'tripId': 't9',
          'date': '2026-11-02',
          'time': '08:00',
          'role': 'passenger',
          'otherUser': {'name': 'Ahmed'},
        },
        {
          'id': 'a5',
          'type': 'activity_reviewed',
          'activityId': 'a5',
          'actionName': 'زراعة شجرة',
          'status': 'approved',
          'proposedPoints': 50,
          'awardedPoints': 40,
          'reason': null,
        },
        {
          'id': 'a6',
          'type': 'activity_reviewed',
          'actionName': 'صياد الهدر',
          'status': 'rejected',
          'reason': 'صورة غير واضحة',
        },
        {'id': 'x', 'type': 'something_new'},
      ],
    },
  });

  test('reads both prompt types in order and skips unknown ones', () {
    expect(prompts.length, 3);
    expect(prompts[0], isA<CarpoolConfirmPrompt>());
    expect(prompts[1], isA<ActivityReviewedPrompt>());
  });

  test('carpool prompt asks about the other person and the trip time', () {
    final trip = prompts[0] as CarpoolConfirmPrompt;
    expect(trip.tripId, 't9');
    expect(trip.title, 'هل تمت الرحلة؟');
    expect(trip.body, 'هل ركبت مع Ahmed يوم 2026-11-02 الساعة 08:00؟');
  });

  test('a driver is asked about the passenger the same way', () {
    final trip = parsePrompts({
      'data': {
        'prompts': [
          {
            'id': 't1',
            'type': 'carpool_confirm',
            'tripId': 't1',
            'date': '2026-11-02',
            'time': '08:00',
            'role': 'driver',
            'otherUser': {'name': null},
          },
        ],
      },
    }).single as CarpoolConfirmPrompt;
    expect(trip.body, 'هل ركب معك الراكب يوم 2026-11-02 الساعة 08:00؟');
  });

  test('approved and rejected reviews read in Arabic', () {
    final approved = prompts[1] as ActivityReviewedPrompt;
    expect(approved.title, 'تم قبول طلبك');
    expect(approved.body, 'زراعة شجرة: حصلت على 40 نقطة.');

    final rejected = prompts[2] as ActivityReviewedPrompt;
    expect(rejected.title, 'لم يتم قبول طلبك');
    expect(rejected.body, 'صياد الهدر: صورة غير واضحة');
  });

  group('tripConfirmResultText', () {
    test('a no cancels the trip', () {
      expect(
        tripConfirmResultText(rode: false, awaitingOther: false, points: 0),
        'تم تسجيل أن الرحلة لم تتم.',
      );
    });

    test('a yes waits for the other side', () {
      expect(
        tripConfirmResultText(rode: true, awaitingOther: true, points: 0),
        'تم تسجيل ردك. ستحصل على النقاط بعد تأكيد الطرف الآخر.',
      );
    });

    test('the second yes confirms and names the points', () {
      expect(
        tripConfirmResultText(rode: true, awaitingOther: false, points: 20),
        'تم تأكيد الرحلة وحصلت على 20 نقطة.',
      );
      expect(
        tripConfirmResultText(rode: true, awaitingOther: false, points: 0),
        'تم تأكيد الرحلة.',
      );
    });
  });
}
