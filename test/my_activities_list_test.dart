import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/my_activities_response_model.dart';
import 'package:green_cycle/modules/my_activities/my_activities_screen.dart';

Future<void> pumpList(WidgetTester tester, List<MyActivity> activities) async {
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
            body: MyActivitiesList(activities: activities, onNearEnd: () {}),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows each request with its status line', (tester) async {
    await pumpList(tester, [
      MyActivity(
        id: '1',
        title: 'زراعة شجرة',
        status: MyActivityStatus.pending,
        proposedPoints: 50,
        createdAt: DateTime(2026, 11, 1),
      ),
      const MyActivity(
        id: '2',
        title: 'صياد الهدر',
        status: MyActivityStatus.rejected,
        rejectionReason: 'صورة غير واضحة',
      ),
    ]);

    expect(find.text('زراعة شجرة'), findsOneWidget);
    expect(find.text('قيد المراجعة · ستحصل على 50 نقطة'), findsOneWidget);
    expect(find.text('2026/11/01'), findsOneWidget);
    expect(find.text('مرفوض · صورة غير واضحة'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('explains an empty list', (tester) async {
    await pumpList(tester, const []);
    expect(find.text('لم ترفع أي نشاط بعد'), findsOneWidget);
  });
}
