import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/request_models/setup_offer_request_model.dart';
import 'package:green_cycle/models/response_models/carpool_offer_response_model.dart';

void main() {
  final offerJson = {
    'status': 'success',
    'data': {
      'offer': {
        '_id': 'offer1',
        'driver': {
          '_id': 'drv1',
          'name': 'Ahmed',
          'phone': 1012345678,
          'avatar': 'http://a/x.jpg',
          'gender': 'male',
        },
        'destinationNameEn': 'Faculty of Pharmacy, Alexandria University',
        'destinationNameAr': 'كلية الصيدلة - جامعة الإسكندرية',
        'weeklySchedule': [
          {'dayOfWeek': 'sunday', 'arrivalTime': '08:00', 'active': true},
          {'dayOfWeek': 'tuesday', 'arrivalTime': '08:30', 'active': true},
        ],
        'checkpoints': [
          {
            'district': {'_id': 'd2', 'nameEn': 'Smouha', 'nameAr': 'سموحة'},
            'order': 1
          },
          {
            'district': {
              '_id': 'd1',
              'nameEn': 'Sidi Bishr',
              'nameAr': 'سيدي بشر'
            },
            'order': 0
          },
        ],
        'isActive': true,
        'notes': '2 seats',
      }
    }
  };

  test('OfferResponseModel parses a populated offer', () {
    final offer = OfferResponseModel.fromMap(offerJson).offer!;
    expect(offer.id, 'offer1');
    expect(offer.driver.name, 'Ahmed');
    expect(offer.driver.phone, 1012345678);
    expect(offer.isActive, isTrue);
    expect(offer.weeklySchedule.length, 2);
  });

  test('checkpoints are sorted by order ascending', () {
    final offer = OfferResponseModel.fromMap(offerJson).offer!;
    expect(offer.checkpoints.map((c) => c.district.id).toList(), ['d1', 'd2']);
  });

  test('OfferResponseModel handles offer: null', () {
    final model = OfferResponseModel.fromMap({
      'data': {'offer': null}
    });
    expect(model.offer, isNull);
  });

  test('SetupOfferRequest.toMap sends checkpoints with the district alias', () {
    final req = SetupOfferRequest(
      weeklySchedule: const [
        WeeklyScheduleEntry(dayOfWeek: 'sunday', arrivalTime: '08:00'),
      ],
      checkpoints: const [
        CheckpointInput(district: 'd1', order: 0),
        CheckpointInput(district: 'd2', order: 1),
      ],
      notes: 'hi',
    );
    final map = req.toMap();
    expect(map['weeklySchedule'][0]['arrivalTime'], '08:00');
    expect(map['weeklySchedule'][0]['active'], true);
    expect(map['checkpoints'][1], {'district': 'd2', 'order': 1});
    expect(map['notes'], 'hi');
    expect(map.containsKey('destinationNameEn'), isFalse);
  });

  test('SetupOfferRequest.toMap omits null notes', () {
    final req = SetupOfferRequest(
      weeklySchedule: const [
        WeeklyScheduleEntry(dayOfWeek: 'sunday', arrivalTime: '08:00')
      ],
      checkpoints: const [CheckpointInput(district: 'd1', order: 0)],
    );
    expect(req.toMap().containsKey('notes'), isFalse);
  });

  test('SetupOfferRequest.toMap omits whitespace-only notes', () {
    final req = SetupOfferRequest(
      weeklySchedule: const [
        WeeklyScheduleEntry(dayOfWeek: 'sunday', arrivalTime: '08:00')
      ],
      checkpoints: const [CheckpointInput(district: 'd1', order: 0)],
      notes: '   ',
    );
    expect(req.toMap().containsKey('notes'), isFalse);
  });

  test('SetupOfferRequest.toMap trims notes', () {
    final req = SetupOfferRequest(
      weeklySchedule: const [
        WeeklyScheduleEntry(dayOfWeek: 'sunday', arrivalTime: '08:00')
      ],
      checkpoints: const [CheckpointInput(district: 'd1', order: 0)],
      notes: '  hi  ',
    );
    expect(req.toMap()['notes'], 'hi');
  });

  test('WeeklyScheduleEntry.fromMap defaults active to true when omitted', () {
    final entry = WeeklyScheduleEntry.fromMap({
      'dayOfWeek': 'sunday',
      'arrivalTime': '08:00',
    });
    expect(entry.active, isTrue);
  });

  test('WeeklyScheduleEntry.fromMap tolerates an empty map', () {
    final entry = WeeklyScheduleEntry.fromMap({});
    expect(entry.dayOfWeek, '');
    expect(entry.arrivalTime, '');
    expect(entry.active, isTrue);
  });

  test('CarpoolOffer.fromMap defaults isActive to true when omitted', () {
    final offer = CarpoolOffer.fromMap({'_id': 'o1'});
    expect(offer.isActive, isTrue);
  });

  test('CarpoolOffer.fromMap preserves an explicit isActive false', () {
    final offer = CarpoolOffer.fromMap({'_id': 'o1', 'isActive': false});
    expect(offer.isActive, isFalse);
  });

  test('CarpoolOffer.fromMap tolerates missing schedule and checkpoints', () {
    final offer = CarpoolOffer.fromMap({'_id': 'o1'});
    expect(offer.weeklySchedule, isEmpty);
    expect(offer.checkpoints, isEmpty);
  });

  test('CarpoolOffer.fromMap tolerates empty schedule and checkpoints lists',
      () {
    final offer = CarpoolOffer.fromMap({
      '_id': 'o1',
      'weeklySchedule': [],
      'checkpoints': [],
    });
    expect(offer.weeklySchedule, isEmpty);
    expect(offer.checkpoints, isEmpty);
  });

  test('parseCheckpoints(null) returns an empty list', () {
    expect(parseCheckpoints(null), isEmpty);
  });

  test('CarpoolOffer.fromMap tolerates a missing driver', () {
    final offer = CarpoolOffer.fromMap({'_id': 'o1'});
    expect(offer.driver.id, '');
    expect(offer.driver.name, '');
    expect(offer.driver.avatar, '');
    expect(offer.driver.gender, '');
    expect(offer.driver.phone, isNull);
  });
}
