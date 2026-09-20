import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/leaderboard_response_model.dart';
import 'package:green_cycle/modules/tabs/streak_board/rank_texts.dart';

LeaderboardEntry entry(String id, int points) => LeaderboardEntry(
      id: id,
      rank: 99, // backend dense rank, deliberately ignored
      name: id,
      avatar: null,
      totalPoints: points,
      serialId: null,
    );

void main() {
  group('rankMessage', () {
    test('first place alone', () {
      expect(
        rankMessage(rank: 1, tiedWith: 1, points: 67, firstPlacePoints: 67),
        'أنت في المركز الأول! حافظ على صدارتك بالمشاركة في الأنشطة البيئية',
      );
    });

    test('first place shared with one other user', () {
      expect(
        rankMessage(rank: 1, tiedWith: 2, points: 67, firstPlacePoints: 67),
        'تتشارك المركز الأول مع مستخدم آخر. اجمع المزيد من النقاط لتنفرد بالصدارة!',
      );
    });

    test('first place shared with several users', () {
      expect(
        rankMessage(rank: 1, tiedWith: 5, points: 67, firstPlacePoints: 67),
        'تتشارك المركز الأول مع 4 مستخدمين آخرين. اجمع المزيد من النقاط لتنفرد بالصدارة!',
      );
    });

    test('second or third shows the gap to first place', () {
      expect(
        rankMessage(
            rank: 2,
            tiedWith: 1,
            points: 60,
            firstPlacePoints: 68,
            thirdPlacePoints: 50),
        'أنت ضمن أفضل 3 طلاب! باقي 8 نقاط للوصول إلى المركز الأول',
      );
      expect(
        rankMessage(
            rank: 3,
            tiedWith: 1,
            points: 50,
            firstPlacePoints: 67,
            thirdPlacePoints: 50),
        'أنت ضمن أفضل 3 طلاب! باقي 17 نقطة للوصول إلى المركز الأول',
      );
    });

    test('below third shows the gap to the top 3', () {
      expect(
        rankMessage(
            rank: 9,
            tiedWith: 4,
            points: 38,
            firstPlacePoints: 67,
            thirdPlacePoints: 50),
        'باقي 12 نقطة لتدخل قائمة أفضل 3 طلاب',
      );
      expect(
        rankMessage(
            rank: 4,
            tiedWith: 1,
            points: 49,
            firstPlacePoints: 67,
            thirdPlacePoints: 50),
        'باقي نقطة واحدة لتدخل قائمة أفضل 3 طلاب',
      );
    });

    test('falls back to a generic line when the top 3 did not load', () {
      expect(
        rankMessage(rank: 2, tiedWith: 1, points: 60),
        'أنت ضمن أفضل 3 طلاب! اجمع المزيد من النقاط للوصول إلى المركز الأول',
      );
      expect(
        rankMessage(rank: 9, tiedWith: 1, points: 38),
        'اجمع المزيد من النقاط لتدخل قائمة أفضل 3 طلاب',
      );
    });

    test('never shows a zero or negative gap', () {
      expect(
        rankMessage(
            rank: 5,
            tiedWith: 1,
            points: 50,
            firstPlacePoints: 67,
            thirdPlacePoints: 50),
        'اجمع المزيد من النقاط لتدخل قائمة أفضل 3 طلاب',
      );
    });

    test('handles an unknown rank', () {
      expect(
        rankMessage(rank: 0, tiedWith: 0, points: 0),
        'اجمع المزيد من النقاط للتقدم في الترتيب!',
      );
    });
  });

  group('podiumRank', () {
    test('numbers distinct scores 1, 2, 3', () {
      final top = [entry('a', 67), entry('b', 60), entry('c', 50)];
      expect(top.map((e) => podiumRank(top, e)), [1, 2, 3]);
    });

    test('matches the my-rank endpoint when scores tie', () {
      // Two students share first, so the next one is third, not second.
      final top = [entry('a', 100), entry('b', 100), entry('c', 90)];
      expect(top.map((e) => podiumRank(top, e)), [1, 1, 3]);
    });
  });
}
