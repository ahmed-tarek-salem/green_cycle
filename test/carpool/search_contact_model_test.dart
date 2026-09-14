import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/request_models/contact_driver_request_model.dart';
import 'package:green_cycle/models/response_models/carpool_search_response_model.dart';
import 'package:green_cycle/models/response_models/contact_driver_response_model.dart';

void main() {
  Map<String, dynamic> resultWithSchedule(dynamic scheduleForDay) => {
        '_id': 'o1',
        'driver': {
          '_id': 'd',
          'name': 'Sara',
          'avatar': 'a',
          'gender': 'female'
        },
        'destinationNameEn': 'x',
        'destinationNameAr': 'كلية',
        'checkpoints': [
          {
            'district': {'_id': 'c1', 'nameEn': 'Smouha', 'nameAr': 'سموحة'},
            'order': 0
          },
        ],
        'scheduleForDay': scheduleForDay,
        'weeklySchedule': [
          {'dayOfWeek': 'sunday', 'arrivalTime': '08:00', 'active': true},
        ],
        'notes': null,
      };

  test('scheduleForDay as an object is parsed', () {
    final model = SearchResponseModel.fromMap({
      'status': 'success',
      'results': 1,
      'data': {
        'offers': [
          resultWithSchedule(
              {'dayOfWeek': 'sunday', 'arrivalTime': '08:00', 'active': true})
        ]
      }
    }, day: 'sunday');
    expect(model.offers.single.scheduleForDay?.arrivalTime, '08:00');
  });

  test('scheduleForDay as an array picks the matching day', () {
    final model = SearchResponseModel.fromMap({
      'data': {
        'offers': [
          resultWithSchedule([
            {'dayOfWeek': 'tuesday', 'arrivalTime': '09:00', 'active': true},
            {'dayOfWeek': 'sunday', 'arrivalTime': '08:15', 'active': true},
          ])
        ]
      }
    }, day: 'sunday');
    expect(model.offers.single.scheduleForDay?.arrivalTime, '08:15');
  });

  test('scheduleForDay as an array with no day match falls back to first', () {
    final model = SearchResponseModel.fromMap({
      'data': {
        'offers': [
          resultWithSchedule([
            {'dayOfWeek': 'tuesday', 'arrivalTime': '09:00', 'active': true},
          ])
        ]
      }
    }, day: 'sunday');
    expect(model.offers.single.scheduleForDay?.arrivalTime, '09:00');
  });

  test('scheduleForDay null/absent → null, and other fields still parse', () {
    final model = SearchResponseModel.fromMap({
      'data': {
        'offers': [resultWithSchedule(null)]
      }
    }, day: 'sunday');
    final r = model.offers.single;
    expect(r.scheduleForDay, isNull);
    expect(r.id, 'o1');
    expect(r.driver.name, 'Sara');
    expect(r.driver.phone, isNull); // search omits phone
    expect(r.checkpoints.single.district.nameAr, 'سموحة');
  });

  test('empty offers list parses to empty', () {
    expect(
        SearchResponseModel.fromMap({
          'data': {'offers': []}
        }).offers,
        isEmpty);
  });

  test('missing offers key parses to empty', () {
    expect(SearchResponseModel.fromMap({'data': {}}).offers, isEmpty);
  });

  test('scheduleForDay as an empty array → null', () {
    final model = SearchResponseModel.fromMap({
      'data': {
        'offers': [resultWithSchedule([])]
      }
    }, day: 'sunday');
    expect(model.offers.single.scheduleForDay, isNull);
  });

  test('scheduleForDay as an array with no day arg falls back to first', () {
    final model = SearchResponseModel.fromMap({
      'data': {
        'offers': [
          resultWithSchedule([
            {'dayOfWeek': 'tuesday', 'arrivalTime': '09:00', 'active': true},
          ])
        ]
      }
    });
    expect(model.offers.single.scheduleForDay?.arrivalTime, '09:00');
  });

  test('ContactDriverResponseModel parses driver + trip', () {
    final model = ContactDriverResponseModel.fromMap({
      'status': 'success',
      'data': {
        'driver': {
          '_id': 'd',
          'name': 'Ahmed',
          'phone': 1012345678,
          'whatsappUrl': 'https://wa.me/201012345678'
        },
        'trip': {'_id': 't1', 'dayOfWeek': 'sunday', 'status': 'contacted'},
      }
    });
    expect(model.driver.whatsappUrl, 'https://wa.me/201012345678');
    expect(model.driver.phone, 1012345678);
    expect(model.trip.status, 'contacted');
  });

  test('ContactDriverResponseModel tolerates missing driver/trip', () {
    final model = ContactDriverResponseModel.fromMap({'data': {}});
    expect(model.driver.name, '');
    expect(model.driver.whatsappUrl, '');
    expect(model.trip.status, '');
  });

  test('ContactDriverRequest.toMap', () {
    expect(ContactDriverRequest(districtId: 'c1', dayOfWeek: 'sunday').toMap(),
        {'districtId': 'c1', 'dayOfWeek': 'sunday'});
  });
}
