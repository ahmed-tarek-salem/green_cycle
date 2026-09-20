import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/modules/tabs/streak_board/widgets/current_user_section.dart';

Future<void> pumpOnSmallPhone(WidgetTester tester, Widget child) async {
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
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('tells the leader they are first, not "a few steps away"',
      (tester) async {
    await pumpOnSmallPhone(
      tester,
      const CurrentUserSection(
        rank: 1,
        name: 'احمد حسن',
        points: 67,
        tiedWith: 1,
        firstPlacePoints: 67,
        thirdPlacePoints: 50,
      ),
    );

    expect(find.textContaining('أنت في المركز الأول!'), findsOneWidget);
    expect(find.textContaining('على بعد خطوات'), findsNothing);
    expect(find.text('67 نقطة'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('fits the longest message on a small phone', (tester) async {
    await pumpOnSmallPhone(
      tester,
      const CurrentUserSection(
        rank: 1,
        name: 'اسم طالب طويل جدا جدا جدا جدا',
        points: 12345,
        tiedWith: 24,
        firstPlacePoints: 12345,
        thirdPlacePoints: 12345,
      ),
    );

    expect(find.textContaining('تتشارك المركز الأول مع 23 مستخدماً آخر'),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows the gap to the top 3 for lower ranks', (tester) async {
    await pumpOnSmallPhone(
      tester,
      const CurrentUserSection(
        rank: 9,
        name: 'طالب',
        points: 45,
        tiedWith: 3,
        firstPlacePoints: 67,
        thirdPlacePoints: 50,
      ),
    );

    expect(find.text('باقي 5 نقاط لتدخل قائمة أفضل 3 طلاب'), findsOneWidget);
    expect(find.text('45 نقطة'), findsOneWidget);
  });
}
