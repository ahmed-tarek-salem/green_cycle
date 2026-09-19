/// Result of the backend version check. Drives the force / optional update UI.
enum AppUpdateStatus {
  /// Check hasn't finished yet, or it failed. The app runs normally.
  unknown,

  /// Installed version is the latest one.
  upToDate,

  /// A newer version exists, the user may skip it.
  optional,

  /// Installed version is no longer supported, the app must be blocked.
  forced,
}

class AppSettingsResponseModel {
  String androidStoreUrl;
  String iosStoreUrl;
  String minSupportedVersion;
  String latestVersion;
  String releaseNotesEn;
  String releaseNotesAr;
  bool updateAvailable;
  bool forceUpdate;
  AppSettingsResponseModel({
    required this.androidStoreUrl,
    required this.iosStoreUrl,
    required this.minSupportedVersion,
    required this.latestVersion,
    required this.releaseNotesEn,
    required this.releaseNotesAr,
    required this.updateAvailable,
    required this.forceUpdate,
  });

  factory AppSettingsResponseModel.fromMap(Map<String, dynamic> map) {
    final data = map['data'];
    final settings = data['settings'];
    final releaseNotes = settings['releaseNotes'] ?? {};
    return AppSettingsResponseModel(
      androidStoreUrl: settings['androidStoreUrl'] ?? '',
      iosStoreUrl: settings['iosStoreUrl'] ?? '',
      minSupportedVersion: settings['minSupportedVersion'] ?? '',
      latestVersion: settings['latestVersion'] ?? '',
      releaseNotesEn: releaseNotes['en'] ?? '',
      releaseNotesAr: releaseNotes['ar'] ?? '',
      // The backend omits both flags when it can't read `currentVersion`.
      updateAvailable: data['updateAvailable'] ?? false,
      forceUpdate: data['forceUpdate'] ?? false,
    );
  }

  AppUpdateStatus get updateStatus {
    if (forceUpdate) return AppUpdateStatus.forced;
    if (updateAvailable) return AppUpdateStatus.optional;
    return AppUpdateStatus.upToDate;
  }

  /// The app is Arabic only, so Arabic notes win and English is the fallback.
  String? get releaseNotes {
    if (releaseNotesAr.trim().isNotEmpty) return releaseNotesAr;
    if (releaseNotesEn.trim().isNotEmpty) return releaseNotesEn;
    return null;
  }

  String storeUrlFor({required bool isIOS}) =>
      isIOS ? iosStoreUrl : androidStoreUrl;
}
