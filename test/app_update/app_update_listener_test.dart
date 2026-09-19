import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/app_settings_response_model.dart';
import 'package:green_cycle/modules/app_update/app_update_controller.dart';
import 'package:green_cycle/modules/app_update/app_update_listener.dart';
import 'package:green_cycle/modules/app_update/app_update_repo.dart';
import 'package:green_cycle/modules/app_update/force_update_screen.dart';

class _FakeRepo extends AppUpdateRepo {
  _FakeRepo(this.result);

  final AppSettingsResponseModel result;

  @override
  Future<AppSettingsResponseModel> getAppSettings(
          String currentVersion) async =>
      result;
}

AppSettingsResponseModel _settings({
  bool updateAvailable = false,
  bool forceUpdate = false,
  String androidStoreUrl = 'https://play.google.com/store/apps/details?id=x',
}) {
  return AppSettingsResponseModel(
    androidStoreUrl: androidStoreUrl,
    iosStoreUrl: '',
    minSupportedVersion: '1.0.0',
    latestVersion: '1.0.6',
    releaseNotesEn: '',
    releaseNotesAr: 'اصلاحات مهمة',
    updateAvailable: updateAvailable,
    forceUpdate: forceUpdate,
  );
}

/// Tests run on a desktop host, so `GetPlatform.isIOS` is false and the
/// Android store url is the one in use.
///
/// Same wiring as `main.dart`: the listener wraps the navigator from the
/// app `builder`, so whatever it shows sits above every route.
Future<void> _pumpApp(
  WidgetTester tester,
  AppSettingsResponseModel settings, {
  Future<bool> Function(String url)? launchStore,
}) async {
  // Phone-sized surface, the default 800x600 one is landscape.
  tester.view.physicalSize = const Size(360 * 3, 728 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  Get.put(AppUpdateController(
    repo: _FakeRepo(settings),
    readVersion: () async => '1.0.5',
    launchStore: launchStore ?? (_) async => true,
  ));
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(360, 728),
      builder: (_, __) => GetMaterialApp(
        builder: (context, child) {
          child = FlutterSmartDialog.init()(context, child);
          return AppUpdateListener(child: child);
        },
        home: const Scaffold(body: Text('home content')),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  tearDown(Get.reset);

  testWidgets('shows nothing when the app is up to date', (tester) async {
    await _pumpApp(tester, _settings());

    expect(find.text('home content'), findsOneWidget);
    expect(find.byType(ForceUpdateScreen), findsNothing);
    expect(find.text('تحديث متاح'), findsNothing);
  });

  testWidgets('covers the whole app with the force update screen',
      (tester) async {
    await _pumpApp(tester, _settings(updateAvailable: true, forceUpdate: true));

    expect(find.byType(ForceUpdateScreen), findsOneWidget);
    expect(find.text('تحديث مطلوب'), findsOneWidget);
    expect(find.text('اصلاحات مهمة'), findsOneWidget);
    expect(find.text('1.0.5'), findsOneWidget);
    expect(find.text('1.0.6'), findsOneWidget);
  });

  testWidgets('force update screen survives navigation underneath it',
      (tester) async {
    await _pumpApp(tester, _settings(updateAvailable: true, forceUpdate: true));

    Get.offAll(() => const Scaffold(body: Text('login')));
    await tester.pumpAndSettle();

    expect(find.byType(ForceUpdateScreen), findsOneWidget);
  });

  testWidgets('hides the update button when the store url is empty',
      (tester) async {
    await _pumpApp(
      tester,
      _settings(updateAvailable: true, forceUpdate: true, androidStoreUrl: ''),
    );

    expect(find.text('تحديث مطلوب'), findsOneWidget);
    expect(find.text('تحديث الآن'), findsNothing);
  });

  testWidgets('update button recovers when the store fails to open',
      (tester) async {
    await _pumpApp(
      tester,
      _settings(updateAvailable: true, forceUpdate: true),
      launchStore: (_) async => throw Exception('no app can open this url'),
    );

    await tester.tap(find.text('تحديث الآن'));
    // Not pumpAndSettle: a stuck loading spinner would animate forever.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('تحديث الآن'), findsOneWidget);
  });

  testWidgets('optional update shows a sheet that "later" dismisses',
      (tester) async {
    await _pumpApp(tester, _settings(updateAvailable: true));

    expect(find.byType(ForceUpdateScreen), findsNothing);
    expect(find.text('تحديث متاح'), findsOneWidget);
    expect(find.text('اصلاحات مهمة'), findsOneWidget);

    await tester.tap(find.text('لاحقاً'));
    await tester.pumpAndSettle();

    expect(find.text('تحديث متاح'), findsNothing);
    expect(Get.find<AppUpdateController>().optionalDismissed, isTrue);
  });
}
