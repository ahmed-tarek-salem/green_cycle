import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';

import 'rewards_fixture.dart';

void main() {
  final catalog = RewardsCatalogResponseModel.fromMap(rewardsCatalogJson());

  test('sorts actions by sortOrder and drops inactive ones', () {
    expect(catalog.actions.map((a) => a.slug), [
      'recycle-dropoff',
      'social-awareness',
      'donate-clothes',
    ]);
  });

  test('reads the three points modes', () {
    final recycle = catalog.actions[0];
    expect(recycle.pointsMode, PointsMode.fixed);
    expect(recycle.points, 20);
    expect(recycle.cooldownDays, 7);
    expect(recycle.verificationAr, 'وزن أو صورة');

    final social = catalog.actions[1];
    expect(social.pointsMode, PointsMode.variants);
    expect(social.variants.map((v) => '${v.key}:${v.labelAr}:${v.points}'), [
      'post:منشور:25',
      'reel:ريل:50',
      'video:فيديو:100',
    ]);

    final clothes = catalog.actions[2];
    expect(clothes.pointsMode, PointsMode.perUnit);
    expect(clothes.unitLabelAr, 'قطعة');
  });

  test('only student actions can be submitted from the app', () {
    RewardAction action(String? submittedBy) => RewardAction.fromMap({
          'slug': 'x',
          if (submittedBy != null) 'submittedBy': submittedBy,
        });

    expect(action('student').isStudentSubmittable, isTrue);
    expect(action('admin').isStudentSubmittable, isFalse);
    expect(action('auto').isStudentSubmittable, isFalse);
    // Older servers send no field, and every action was a student one then.
    expect(action(null).isStudentSubmittable, isTrue);
  });

  test('sorts levels by order and keeps an open-ended last level', () {
    expect(catalog.levels.map((l) => l.titleAr), [
      'البذرة الخضراء',
      'البرعم الواعد',
      'قائد التغيير الأخضر',
    ]);
    expect(catalog.levels.first.maxPoints, 499);
    expect(catalog.levels.last.maxPoints, isNull);
  });

  test('sorts prizes and reads the bonus config', () {
    expect(catalog.prizes.first.icon, '🪐');
    expect(catalog.config.firstGreenActivityPoints, 100);
    expect(catalog.config.firstMilestoneCount, 50);
    expect(catalog.config.repeatingMilestoneCount, 100);
  });

  test('treats an unknown points mode as fixed', () {
    final action = RewardAction.fromMap(const {
      'slug': 'x',
      'pointsMode': 'something-new',
      'points': 7,
    });
    expect(action.pointsMode, PointsMode.fixed);
    expect(action.points, 7);
  });

  test('survives an empty payload', () {
    final empty = RewardsCatalogResponseModel.fromMap(const {});
    expect(empty.actions, isEmpty);
    expect(empty.levels, isEmpty);
    expect(empty.prizes, isEmpty);
    expect(empty.config.signupPoints, 0);
  });
}
