import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/request_models/activity_request_model.dart';

void main() {
  group('ActivityRequestModel.toMap', () {
    test('sends the catalog slug when one is set', () {
      final map = ActivityRequestModel(
        type: 'action',
        summary: 'note',
        details: 'note',
        image: null,
        rewardActionSlug: 'recycle-dropoff',
      ).toMap();

      expect(map['rewardActionSlug'], 'recycle-dropoff');
    });

    test('omits the slug for complaints', () {
      final map = ActivityRequestModel(
        type: 'suggestion',
        summary: 'title',
        details: 'details',
        image: null,
      ).toMap();

      expect(map.containsKey('rewardActionSlug'), isFalse);
    });

    test('never sends a points value', () {
      final map = ActivityRequestModel(
        type: 'action',
        summary: 'note',
        details: 'note',
        image: null,
        rewardActionSlug: 'recycle-dropoff',
      ).toMap();

      expect(map.containsKey('points'), isFalse);
    });
  });
}
