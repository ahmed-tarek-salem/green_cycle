import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/my_rewards_response_model.dart';
import 'package:green_cycle/modules/tabs/home/widgets/level_progress.dart';

Map<String, dynamic> level(
        String title, String emoji, int min, String reward) =>
    {
      'titleAr': title,
      'emoji': emoji,
      'minPoints': min,
      'rewardAr': reward,
    };

Future<void> pumpOnSmallPhone(
    WidgetTester tester, MyRewardsResponseModel rewards) async {
  tester.view.devicePixelRatio = 2;
  tester.view.physicalSize = const Size(320 * 2, 640 * 2);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(360, 728),
      builder: (_, __) => MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(30),
              child: LevelProgress(rewards: rewards),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows the level, the remaining points and the next reward',
      (tester) async {
    await pumpOnSmallPhone(
      tester,
      MyRewardsResponseModel.fromMap({
        'data': {
          'totalPoints': 120,
          'level': level('البذرة الخضراء', '🌱', 0, 'ملصقات'),
          'nextLevel': level('البرعم الواعد', '🌿', 500,
              'أدوات مكتبية جامعية (قلم / دفتر) وهدايا أخرى كثيرة جدا جدا جدا'),
          'pointsToNextLevel': 380,
        },
      }),
    );

    expect(find.text('مستواك: البذرة الخضراء 🌱'), findsOneWidget);
    expect(
        find.text('باقي 380 نقطة للوصول إلى البرعم الواعد 🌿'), findsOneWidget);
    expect(find.textContaining('جائزة المستوى القادم:'), findsOneWidget);
    final bar = tester
        .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
    expect(bar.value, closeTo(0.24, 1e-9));
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a full bar and the current reward on the last level',
      (tester) async {
    await pumpOnSmallPhone(
      tester,
      MyRewardsResponseModel.fromMap({
        'data': {
          'totalPoints': 7000,
          'level': level('قائد التغيير الأخضر', '🏆', 6000,
              'نشر الاسم والصورة على الصفحة الرسمية للكلية + هدايا مخصصة'),
          'nextLevel': null,
          'pointsToNextLevel': 0,
        },
      }),
    );

    expect(find.text('وصلت لأعلى مستوى!'), findsOneWidget);
    expect(find.textContaining('جائزتك:'), findsOneWidget);
    final bar = tester
        .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
    expect(bar.value, 1.0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('hides the reward line when the level has no reward',
      (tester) async {
    await pumpOnSmallPhone(
      tester,
      MyRewardsResponseModel.fromMap({
        'data': {
          'totalPoints': 10,
          'level': level('البذرة الخضراء', '🌱', 0, ''),
          'nextLevel': level('البرعم الواعد', '🌿', 500, ''),
          'pointsToNextLevel': 490,
        },
      }),
    );

    expect(find.textContaining('جائزة'), findsNothing);
  });
}
