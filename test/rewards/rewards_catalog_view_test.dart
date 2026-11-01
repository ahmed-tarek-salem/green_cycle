import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';
import 'package:green_cycle/modules/rewards/widgets/rewards_catalog_view.dart';

import 'rewards_fixture.dart';

Future<void> pumpView(
  WidgetTester tester, {
  int totalPoints = 120,
  int initialTab = 0,
}) async {
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
            body: RewardsCatalogView(
              catalog: RewardsCatalogResponseModel.fromMap(
                rewardsCatalogJson(),
              ),
              totalPoints: totalPoints,
              initialTab: initialTab,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('activities tab lists actions with points, proof and cooldown', (
    tester,
  ) async {
    await pumpView(tester);

    expect(
      find.text('تسليم مخلفات ورقية أو بلاستيكية للتدوير'),
      findsOneWidget,
    );
    expect(find.text('20 نقطة'), findsOneWidget);
    expect(find.text('طريقة الإثبات: وزن أو صورة'), findsOneWidget);
    expect(find.text('مرة واحدة كل 7 أيام'), findsOneWidget);
    expect(find.text('ريل: 50 نقطة'), findsOneWidget);
    expect(find.text('نشاط موقوف'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('activities tab ends with the automatic bonuses', (tester) async {
    await pumpView(tester);

    // The first Scrollable is the horizontal tab pager, so target the list.
    await tester.scrollUntilVisible(
      find.text('مكافآت تلقائية'),
      300,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('أول نشاط بيئي معتمد: 100 نقطة'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('levels tab marks the current level only', (tester) async {
    await pumpView(tester, totalPoints: 620);

    await tester.tap(find.text('المستويات'));
    await tester.pumpAndSettle();

    expect(find.text('البرعم الواعد'), findsOneWidget);
    expect(find.text('من 500 إلى 999 نقطة'), findsOneWidget);
    expect(find.text('6000 نقطة فأكثر'), findsOneWidget);
    expect(find.text('الجائزة: ملصقات'), findsOneWidget);
    expect(find.text('مستواك'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('prizes tab lists the special prizes', (tester) async {
    await pumpView(tester);

    await tester.tap(find.text('الجوائز'));
    await tester.pumpAndSettle();

    expect(find.text('مقابلة مع عميد الكلية وتكريم رسمي'), findsOneWidget);
    expect(find.text('جائزة مفاجئة ضمن فعاليات خاصة.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('can open directly on the levels tab', (tester) async {
    await pumpView(tester, initialTab: 1);

    expect(find.text('مستواك'), findsOneWidget);
  });
}
