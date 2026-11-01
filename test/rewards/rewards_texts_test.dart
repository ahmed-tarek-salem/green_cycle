import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';
import 'package:green_cycle/modules/rewards/rewards_texts.dart';

import 'rewards_fixture.dart';

void main() {
  final catalog = RewardsCatalogResponseModel.fromMap(rewardsCatalogJson());

  group('actionPointsTexts', () {
    test('fixed shows one amount', () {
      expect(actionPointsTexts(catalog.actions[0]), ['20 نقطة']);
    });

    test('variants show one amount per variant', () {
      expect(actionPointsTexts(catalog.actions[1]), [
        'منشور: 25 نقطة',
        'ريل: 50 نقطة',
        'فيديو: 100 نقطة',
      ]);
    });

    test('per unit names the unit', () {
      expect(actionPointsTexts(catalog.actions[2]), ['50 نقطة لكل قطعة']);
    });

    test('variants mode without variants falls back to the base amount', () {
      final action = RewardAction.fromMap(const {
        'slug': 'x',
        'pointsMode': 'variants',
        'points': 25,
      });
      expect(actionPointsTexts(action), ['25 نقطة']);
    });
  });

  test('cooldownText', () {
    expect(cooldownText(0), isNull);
    expect(cooldownText(1), 'مرة واحدة كل يوم');
    expect(cooldownText(2), 'مرة واحدة كل يومين');
    expect(cooldownText(7), 'مرة واحدة كل 7 أيام');
    expect(cooldownText(30), 'مرة واحدة كل 30 يوماً');
  });

  test('levelRangeText', () {
    expect(levelRangeText(catalog.levels.first), 'من 0 إلى 499 نقطة');
    expect(levelRangeText(catalog.levels.last), '6000 نقطة فأكثر');
  });

  test('currentLevelIndex picks the highest level the points reach', () {
    expect(currentLevelIndex(catalog.levels, 0), 0);
    expect(currentLevelIndex(catalog.levels, 499), 0);
    expect(currentLevelIndex(catalog.levels, 500), 1);
    expect(currentLevelIndex(catalog.levels, 9000), 2);
    expect(currentLevelIndex(const [], 10), -1);
  });

  test('activitiesLabel', () {
    expect(activitiesLabel(1), 'نشاط واحد');
    expect(activitiesLabel(2), 'نشاطين');
    expect(activitiesLabel(5), '5 أنشطة');
    expect(activitiesLabel(50), '50 نشاطاً');
    expect(activitiesLabel(100), '100 نشاط');
  });

  group('bonusLines', () {
    test('lists every automatic bonus from the config', () {
      expect(bonusLines(catalog.config), [
        'عند إنشاء حسابك: 50 نقطة',
        'أول نشاط بيئي معتمد: 100 نقطة',
        'عند إكمال 50 نشاطاً: 100 نقطة',
        'كل 100 نشاط: 100 نقطة',
      ]);
    });

    test('skips bonuses the college switched off', () {
      final config = RewardsConfig.fromMap(const {
        'signupPoints': 0,
        'firstGreenActivityPoints': 100,
        'firstMilestoneCount': 0,
        'firstMilestonePoints': 100,
        'repeatingMilestoneCount': 100,
        'repeatingMilestonePoints': 0,
      });
      expect(bonusLines(config), ['أول نشاط بيئي معتمد: 100 نقطة']);
    });
  });
}
