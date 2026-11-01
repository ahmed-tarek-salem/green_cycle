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

    test('sends the variant and the units when the action needs them', () {
      final map = ActivityRequestModel(
        type: 'action',
        summary: '',
        details: 'https://example.com/reel',
        image: null,
        rewardActionSlug: 'social-awareness',
        variantKey: 'reel',
        units: 3,
      ).toMap();

      expect(map['variantKey'], 'reel');
      expect(map['units'], 3);
    });

    test('omits the variant and the units for a plain action', () {
      final map = ActivityRequestModel(
        type: 'action',
        summary: '',
        details: '',
        image: null,
        rewardActionSlug: 'recycle-dropoff',
      ).toMap();

      expect(map.containsKey('variantKey'), isFalse);
      expect(map.containsKey('units'), isFalse);
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
