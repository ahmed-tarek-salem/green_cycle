import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/app_settings_response_model.dart';
import 'package:green_cycle/modules/app_update/app_update_repo.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Drives the force / optional update UI. The check runs in the background on
/// app start and never delays or blocks the launch flow, `AppUpdateListener`
/// reacts to [status] whenever the answer arrives.
class AppUpdateController extends GetxController {
  AppUpdateController({
    AppUpdateRepo? repo,
    Future<String> Function()? readVersion,
    Future<bool> Function(String url)? launchStore,
  })  : _repo = repo ?? AppUpdateRepo(),
        _readVersion = readVersion ?? _readInstalledVersion,
        _launchStore = launchStore ?? _launchExternally;

  final AppUpdateRepo _repo;
  final Future<String> Function() _readVersion;
  final Future<bool> Function(String url) _launchStore;

  final Rx<AppUpdateStatus> status = AppUpdateStatus.unknown.obs;
  AppSettingsResponseModel? settings;
  String currentVersion = '';

  /// Session-scoped flag, once the user skips the optional prompt it stays
  /// hidden until the next app start.
  bool optionalDismissed = false;

  String get storeUrl => settings?.storeUrlFor(isIOS: GetPlatform.isIOS) ?? '';

  @override
  void onInit() {
    checkForUpdate();
    super.onInit();
  }

  Future<void> checkForUpdate() async {
    try {
      currentVersion = await _readVersion();
      final data = await _repo.getAppSettings(currentVersion);
      settings = data;
      status.value = data.updateStatus;
    } catch (_) {
      // The version check is non-critical, a failure must never block the app.
    }
  }

  /// Never throws: a failed launch must not leave the update button stuck in
  /// its loading state, the force update screen has no other way out.
  Future<bool> openStore() async {
    if (storeUrl.isEmpty) return false;
    try {
      return await _launchStore(storeUrl);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _launchExternally(String url) =>
      launchUrlString(url, mode: LaunchMode.externalApplication);

  /// `versionName` / `CFBundleShortVersionString`, without the build number.
  static Future<String> _readInstalledVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }
}
