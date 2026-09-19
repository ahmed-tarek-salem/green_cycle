import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/app_settings_response_model.dart';
import 'package:green_cycle/modules/app_update/app_update_controller.dart';
import 'package:green_cycle/modules/app_update/app_update_repo.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class _FakeRepo extends AppUpdateRepo {
  _FakeRepo({this.result});

  final AppSettingsResponseModel? result;
  String? requestedVersion;

  @override
  Future<AppSettingsResponseModel> getAppSettings(String currentVersion) async {
    requestedVersion = currentVersion;
    if (result == null) throw MyCustomException('no internet');
    return result!;
  }
}

AppSettingsResponseModel _settings({
  bool updateAvailable = false,
  bool forceUpdate = false,
}) {
  return AppSettingsResponseModel(
    androidStoreUrl: 'https://play.google.com/store/apps/details?id=x',
    iosStoreUrl: 'https://apps.apple.com/eg/app/green-cycle/id0',
    minSupportedVersion: '1.0.0',
    latestVersion: '1.0.6',
    releaseNotesEn: '',
    releaseNotesAr: '',
    updateAvailable: updateAvailable,
    forceUpdate: forceUpdate,
  );
}

void main() {
  test('status is unknown before the check finishes', () {
    final controller = AppUpdateController(
      repo: _FakeRepo(result: _settings()),
      readVersion: () async => '1.0.5',
    );
    expect(controller.status.value, AppUpdateStatus.unknown);
  });

  test('sends the installed version to the backend', () async {
    final repo = _FakeRepo(result: _settings());
    final controller =
        AppUpdateController(repo: repo, readVersion: () async => '1.0.5');

    await controller.checkForUpdate();

    expect(repo.requestedVersion, '1.0.5');
    expect(controller.currentVersion, '1.0.5');
  });

  test('exposes the status the backend decided', () async {
    final controller = AppUpdateController(
      repo: _FakeRepo(
          result: _settings(updateAvailable: true, forceUpdate: true)),
      readVersion: () async => '0.9.0',
    );

    await controller.checkForUpdate();

    expect(controller.status.value, AppUpdateStatus.forced);
    expect(controller.settings?.latestVersion, '1.0.6');
  });

  test('openStore opens the store listing of the running platform', () async {
    String? openedUrl;
    final controller = AppUpdateController(
      repo: _FakeRepo(result: _settings(updateAvailable: true)),
      readVersion: () async => '1.0.5',
      launchStore: (url) async {
        openedUrl = url;
        return true;
      },
    );
    await controller.checkForUpdate();

    expect(await controller.openStore(), isTrue);
    // Tests run on a desktop host, so the Android listing is the one in use.
    expect(openedUrl, 'https://play.google.com/store/apps/details?id=x');
  });

  test('openStore reports a failure instead of throwing', () async {
    final controller = AppUpdateController(
      repo: _FakeRepo(result: _settings(updateAvailable: true)),
      readVersion: () async => '1.0.5',
      launchStore: (_) async => throw Exception('no app can open this url'),
    );
    await controller.checkForUpdate();

    expect(await controller.openStore(), isFalse);
  });

  test('stays unknown when the check fails, so the app is never blocked',
      () async {
    final controller = AppUpdateController(
      repo: _FakeRepo(),
      readVersion: () async => '1.0.5',
    );

    await controller.checkForUpdate();

    expect(controller.status.value, AppUpdateStatus.unknown);
    expect(controller.settings, isNull);
  });
}
