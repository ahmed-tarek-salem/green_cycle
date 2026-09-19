import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/app_settings_response_model.dart';

Map<String, dynamic> _response({
  bool? updateAvailable,
  bool? forceUpdate,
  String en = 'Important fixes',
  String ar = 'اصلاحات مهمة',
}) {
  return {
    'status': 'success',
    'data': {
      'settings': {
        '_id': '6aadb228ea1d1a43324de1ef',
        'androidStoreUrl': 'https://play.google.com/store/apps/details?id=x',
        'iosStoreUrl': 'https://apps.apple.com/eg/app/green-cycle/id0',
        'minSupportedVersion': '1.0.0',
        'latestVersion': '1.0.1',
        'releaseNotes': {'en': en, 'ar': ar},
      },
      if (updateAvailable != null) 'updateAvailable': updateAvailable,
      if (forceUpdate != null) 'forceUpdate': forceUpdate,
    },
  };
}

void main() {
  group('updateStatus', () {
    test('forced when the backend flags forceUpdate', () {
      final model = AppSettingsResponseModel.fromMap(
          _response(updateAvailable: true, forceUpdate: true));
      expect(model.updateStatus, AppUpdateStatus.forced);
    });

    test('optional when only updateAvailable is flagged', () {
      final model = AppSettingsResponseModel.fromMap(
          _response(updateAvailable: true, forceUpdate: false));
      expect(model.updateStatus, AppUpdateStatus.optional);
    });

    test('upToDate when no flag is set', () {
      final model = AppSettingsResponseModel.fromMap(
          _response(updateAvailable: false, forceUpdate: false));
      expect(model.updateStatus, AppUpdateStatus.upToDate);
    });

    test('upToDate when the backend omits the flags', () {
      final model = AppSettingsResponseModel.fromMap(_response());
      expect(model.updateStatus, AppUpdateStatus.upToDate);
    });
  });

  group('releaseNotes', () {
    test('prefers the Arabic notes', () {
      final model = AppSettingsResponseModel.fromMap(_response());
      expect(model.releaseNotes, 'اصلاحات مهمة');
    });

    test('falls back to English when Arabic is empty', () {
      final model = AppSettingsResponseModel.fromMap(_response(ar: ''));
      expect(model.releaseNotes, 'Important fixes');
    });

    test('null when both are empty', () {
      final model =
          AppSettingsResponseModel.fromMap(_response(ar: '', en: ' '));
      expect(model.releaseNotes, isNull);
    });
  });

  group('storeUrlFor', () {
    test('picks the store listing of the running platform', () {
      final model = AppSettingsResponseModel.fromMap(_response());
      expect(model.storeUrlFor(isIOS: true),
          'https://apps.apple.com/eg/app/green-cycle/id0');
      expect(model.storeUrlFor(isIOS: false),
          'https://play.google.com/store/apps/details?id=x');
    });
  });
}
