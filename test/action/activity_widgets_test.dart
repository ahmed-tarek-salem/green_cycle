import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';
import 'package:green_cycle/modules/action/widgets/activity_form_fields.dart';
import 'package:green_cycle/modules/action/widgets/activity_picker_list.dart';

import '../rewards/rewards_fixture.dart';

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
          child: Scaffold(body: child),
        ),
      ),
    ),
  );
}

void main() {
  final catalog = RewardsCatalogResponseModel.fromMap(rewardsCatalogJson());
  final recycle = catalog.actions[0];
  final social = catalog.actions[1];
  final clothes = catalog.actions[2];

  testWidgets('picker lists every activity and reports the tapped one', (
    tester,
  ) async {
    RewardAction? picked;
    await pumpOnSmallPhone(
      tester,
      ActivityPickerList(
        actions: catalog.actions,
        onSelected: (action) => picked = action,
      ),
    );

    expect(find.text('اختر النشاط الذي قمت به'), findsOneWidget);
    expect(find.text(recycle.nameAr), findsOneWidget);
    expect(find.text(social.nameAr), findsOneWidget);

    await tester.tap(find.text(social.nameAr));
    expect(picked?.slug, 'social-awareness');
    expect(tester.takeException(), isNull);
  });

  testWidgets('picker explains an empty catalog', (tester) async {
    await pumpOnSmallPhone(
      tester,
      ActivityPickerList(actions: const [], onSelected: (_) {}),
    );

    expect(find.text('لا توجد أنشطة متاحة حالياً'), findsOneWidget);
  });

  testWidgets('a fixed activity needs no extra fields', (tester) async {
    await pumpOnSmallPhone(
      tester,
      ActivityFormFields(
        action: recycle,
        variantKey: null,
        units: 1,
        onVariantSelected: (_) {},
        onUnitsChanged: (_) {},
      ),
    );

    expect(find.text('اختر النوع'), findsNothing);
    expect(find.textContaining('العدد'), findsNothing);
  });

  testWidgets('variants are offered as choices', (tester) async {
    String? chosen;
    await pumpOnSmallPhone(
      tester,
      ActivityFormFields(
        action: social,
        variantKey: null,
        units: 1,
        onVariantSelected: (key) => chosen = key,
        onUnitsChanged: (_) {},
      ),
    );

    expect(find.text('اختر النوع'), findsOneWidget);
    await tester.tap(find.text('ريل: 50 نقطة'));
    expect(chosen, 'reel');
    expect(tester.takeException(), isNull);
  });

  testWidgets('per unit shows a stepper and the running total', (tester) async {
    int? changedTo;
    await pumpOnSmallPhone(
      tester,
      ActivityFormFields(
        action: clothes,
        variantKey: null,
        units: 3,
        onVariantSelected: (_) {},
        onUnitsChanged: (value) => changedTo = value,
      ),
    );

    expect(find.text('العدد (قطعة)'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('الإجمالي: 150 نقطة'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    expect(changedTo, 4);
    await tester.tap(find.byIcon(Icons.remove));
    expect(changedTo, 2);
  });

  testWidgets('the stepper never goes below one', (tester) async {
    int? changedTo;
    await pumpOnSmallPhone(
      tester,
      ActivityFormFields(
        action: clothes,
        variantKey: null,
        units: 1,
        onVariantSelected: (_) {},
        onUnitsChanged: (value) => changedTo = value,
      ),
    );

    await tester.tap(find.byIcon(Icons.remove));
    expect(changedTo, isNull);
  });
}
