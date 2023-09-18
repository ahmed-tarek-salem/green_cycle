import 'package:dio/dio.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';

class DioClient {
  static const baseUrl = AppEndpoints.baseUrl;
  static final _options = BaseOptions(
    connectTimeout: const Duration(seconds: 90),
    baseUrl: baseUrl,
    contentType: 'application/json',
  );

  static final privateDio = Dio(_options);
  static final publicDio = Dio(_options);

  static void login(String token) {
    privateDio.options.headers['Authorization'] = 'Bearer $token';
  }

  static void logout() {
    privateDio.options.headers.remove('Authorization');
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
  }

  /// Add Headers *******************************************
  Map<String, String> getHeaders(String lang) {
    return {
      // 'Accept': 'application/json',
      // 'Content-Type': 'application/json',
      'Accept-Language': 'lang',
    };
  }
}
