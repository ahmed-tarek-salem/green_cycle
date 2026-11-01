import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/my_rewards_response_model.dart';

Map<String, dynamic> levelJson({
  required String titleAr,
  required String emoji,
  required int minPoints,
  int? maxPoints,
  String rewardAr = '',
}) =>
    {
      '_id': 'id-$minPoints',
      'order': 1,
      'titleAr': titleAr,
      'titleEn': 'x',
      'minPoints': minPoints,
      'maxPoints': maxPoints,
      'rewardAr': rewardAr,
      'rewardEn': 'x',
      'emoji': emoji,
      'active': true,
    };

void main() {
  group('MyRewardsResponseModel pending activities', () {
    test('collects the slugs the student has a pending request for', () {
      final model = MyRewardsResponseModel.fromMap({
        'data': {
          'totalPoints': 0,
          'actions': [
            {'slug': 'plant-tree', 'hasPending': true},
            {'slug': 'reusable-bottle', 'hasPending': false},
            {'slug': 'recycled-art'},
          ],
        },
      });
      expect(model.pendingSlugs, {'plant-tree'});
    });

    test('is empty when the server sends no actions', () {
      final model = MyRewardsResponseModel.fromMap({
        'data': <String, dynamic>{'totalPoints': 0},
      });
      expect(model.pendingSlugs, isEmpty);
    });
  });

  group('MyRewardsResponseModel.fromMap', () {
    test('reads points, current level and next level', () {
      final model = MyRewardsResponseModel.fromMap({
        'status': 'success',
        'data': {
          'totalPoints': 120,
          'level': levelJson(
              titleAr: 'البذرة الخضراء',
              emoji: '🌱',
              minPoints: 0,
              maxPoints: 499,
              rewardAr: 'ملصقات'),
          'nextLevel': levelJson(
              titleAr: 'البرعم الواعد',
              emoji: '🌿',
              minPoints: 500,
              maxPoints: 999,
              rewardAr: 'أدوات مكتبية'),
          'pointsToNextLevel': 380,
          'badges': [],
        },
      });

      expect(model.totalPoints, 120);
      expect(model.level!.titleAr, 'البذرة الخضراء');
      expect(model.level!.emoji, '🌱');
      expect(model.nextLevel!.titleAr, 'البرعم الواعد');
      expect(model.nextLevel!.rewardAr, 'أدوات مكتبية');
      expect(model.pointsToNextLevel, 380);
    });

    test('treats a missing next level as the last level', () {
      final model = MyRewardsResponseModel.fromMap({
        'data': {
          'totalPoints': 7000,
          'level': levelJson(
              titleAr: 'قائد التغيير الأخضر', emoji: '🏆', minPoints: 6000),
          'nextLevel': null,
          'pointsToNextLevel': 0,
        },
      });

      expect(model.nextLevel, isNull);
      expect(model.isLastLevel, isTrue);
      expect(model.levelProgress, 1.0);
    });

    test('survives an empty payload', () {
      final model = MyRewardsResponseModel.fromMap(const {});

      expect(model.totalPoints, 0);
      expect(model.level, isNull);
      expect(model.levelProgress, 0.0);
    });
  });

  group('levelProgress', () {
    MyRewardsResponseModel build(int points, {int min = 0, int next = 500}) =>
        MyRewardsResponseModel.fromMap({
          'data': {
            'totalPoints': points,
            'level': levelJson(titleAr: 'a', emoji: '🌱', minPoints: min),
            'nextLevel': levelJson(titleAr: 'b', emoji: '🌿', minPoints: next),
            'pointsToNextLevel': next - points,
          },
        });

    test('is the share of the way to the next level', () {
      expect(build(120).levelProgress, closeTo(0.24, 1e-9));
      expect(build(750, min: 500, next: 1000).levelProgress, 0.5);
    });

    test('stays between 0 and 1', () {
      expect(build(-10).levelProgress, 0.0);
      expect(build(900).levelProgress, 1.0);
    });

    test('is full when the level range is empty', () {
      expect(build(500, min: 500, next: 500).levelProgress, 1.0);
    });
  });
}
