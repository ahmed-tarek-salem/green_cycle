import 'package:get_storage/get_storage.dart';

///Storage Keys
enum LocalStorageKeys { keyAppLocal, keyToken, user }

class LocalStorage {
  //Data
  late GetStorage _storage;

  //init
  Future<void> init() async {
    await GetStorage.init();
    _storage = GetStorage();
  }

  ///App Locale ****************************************************************
  String? getLocale() {
    return _storage.read(LocalStorageKeys.keyAppLocal.toString()); // Language
  }

  void setLocale(String? language) {
    _storage.write(LocalStorageKeys.keyAppLocal.toString(), language);
  }

  ///Token ****************************************************************
  String? getToken() {
    return _storage.read(LocalStorageKeys.keyToken.toString());
  }

  void setToken(String token) {
    _storage.write(LocalStorageKeys.keyToken.toString(), token);
  }

  void clearToken() {
    _storage.remove(LocalStorageKeys.keyToken.toString());
  }

  ///Clear *********************************************************************
  Future<void> clear() async {
    String? local = getLocale();
    await _storage.erase();
    setLocale(local);
  }
}
