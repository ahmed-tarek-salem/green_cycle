import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';
import 'package:green_cycle/utilities/network/auth_session.dart';
import 'package:green_cycle/utilities/storage/local_storage.dart';

class DioClient {
  static String get baseUrl => AppEndpoints.baseUrl;
  static final _options = BaseOptions(
    connectTimeout: const Duration(seconds: 90),
    baseUrl: baseUrl,
    contentType: 'application/json',
  );

  static final privateDio = Dio(_options);
  static final publicDio = Dio(_options);

  /// True while an expired-session redirect to login is in flight, so we can
  /// suppress the generic error dialogs that the in-flight requests would
  /// otherwise stack on top of the login screen.
  static bool isHandlingSessionExpiry = false;

  static void login(String token) {
    privateDio.options.headers['Cookie'] = 'JWT=$token';
    // A fresh, valid token means the session is healthy again.
    isHandlingSessionExpiry = false;
  }

  static void logout() {
    privateDio.options.headers.remove('Cookie');
  }

  static void initialize(String lang) {
    for (var dio in [privateDio, publicDio]) {
      dio.interceptors.add(
        LogInterceptor(
            responseBody: true,
            requestBody: true,
            error: true,
            requestHeader: true,
            request: true),
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
            options.headers.addAll({
              'Accept-Language': lang,
              'Accept': 'application/json',
            });
            handler.next(options);
          },
        ),
      );
    }

    // Auth-expiry safety net for protected calls only. Login uses `publicDio`,
    // so an "invalid credentials" 401 there never triggers this redirect.
    privateDio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException err, ErrorInterceptorHandler handler) {
          if (AuthSession.isAuthExpiryError(err.response?.statusCode)) {
            _handleSessionExpired();
          }
          handler.next(err);
        },
      ),
    );
  }

  /// Clears the session and sends the user back to login exactly once, even if
  /// several protected requests fail at the same time.
  static void _handleSessionExpired() {
    if (isHandlingSessionExpiry) return;
    if (Get.currentRoute == AppRoutes.loginScreen) return;
    isHandlingSessionExpiry = true;

    SmartDialog.dismiss();
    logout();
    try {
      Get.find<LocalStorage>().clearToken();
    } catch (_) {}

    Get.offAllNamed(AppRoutes.loginScreen);
    Get.snackbar(
      'انتهت الجلسة',
      'برجاء تسجيل الدخول مرة أخرى',
      snackPosition: SnackPosition.BOTTOM,
    );

    // Reopen normal error handling once the redirect settles, in case the flag
    // is not cleared by a subsequent successful login.
    Future.delayed(const Duration(seconds: 2), () {
      isHandlingSessionExpiry = false;
    });
  }
}

class MyCustomException implements Exception {
  final String message;

  /// The server's stable error code, such as `PENDING_SAME_ACTION`, when the
  /// response has one.
  final String? code;

  MyCustomException(this.message, {this.code});
}
