import 'dart:convert';

/// Pure helpers for reasoning about the JWT session, with no Flutter/GetX
/// dependencies so they can be unit-tested in isolation.
class AuthSession {
  /// Whether a failed response indicates the login session is no longer valid
  /// and the user must re-authenticate.
  ///
  /// The backend returns `401` for an expired or invalid token, so a plain
  /// status-code check is enough.
  static bool isAuthExpiryError(int? statusCode) => statusCode == 401;

  /// Whether [token] is a JWT whose `exp` claim is in the past.
  ///
  /// Returns `true` for any token we cannot parse or that lacks a usable `exp`,
  /// so a malformed / unexpected token forces a fresh login rather than being
  /// trusted. Pass [now] in tests for deterministic results.
  static bool isJwtExpired(String? token, {DateTime? now}) {
    if (token == null || token.isEmpty) return true;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload =
          json.decode(_decodeBase64Url(parts[1])) as Map<String, dynamic>;
      final exp = payload['exp'];
      if (exp is! int) return true;
      final expiry =
          DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
      final current = (now ?? DateTime.now()).toUtc();
      return !current.isBefore(expiry);
    } catch (_) {
      return true;
    }
  }

  static String _decodeBase64Url(String segment) {
    var output = segment.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw const FormatException('Invalid base64url string');
    }
    return utf8.decode(base64.decode(output));
  }
}
