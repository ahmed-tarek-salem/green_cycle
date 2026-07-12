import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/utilities/network/auth_session.dart';

String _tokenWithExp(int expSeconds) {
  final payload =
      base64Url.encode(utf8.encode(json.encode({'exp': expSeconds}))).replaceAll('=', '');
  return 'header.$payload.signature';
}

void main() {
  group('isAuthExpiryError', () {
    test('true only for 401', () {
      expect(AuthSession.isAuthExpiryError(401), isTrue);
    });

    test('false for any other status, including a 500', () {
      // The backend must return 401 for an expired token; a 500 is treated as a
      // generic server error, not a session expiry.
      expect(AuthSession.isAuthExpiryError(500), isFalse);
      expect(AuthSession.isAuthExpiryError(200), isFalse);
      expect(AuthSession.isAuthExpiryError(404), isFalse);
      expect(AuthSession.isAuthExpiryError(null), isFalse);
    });
  });

  group('isJwtExpired', () {
    final now = DateTime.utc(2026, 7, 11, 22, 19, 15);

    test('true when exp is in the past', () {
      final expired = _tokenWithExp(DateTime.utc(2026, 6, 13).millisecondsSinceEpoch ~/ 1000);
      expect(AuthSession.isJwtExpired(expired, now: now), isTrue);
    });

    test('false when exp is in the future', () {
      final valid = _tokenWithExp(DateTime.utc(2026, 9, 13).millisecondsSinceEpoch ~/ 1000);
      expect(AuthSession.isJwtExpired(valid, now: now), isFalse);
    });

    test('true for null, empty, malformed, or exp-less tokens', () {
      expect(AuthSession.isJwtExpired(null, now: now), isTrue);
      expect(AuthSession.isJwtExpired('', now: now), isTrue);
      expect(AuthSession.isJwtExpired('not-a-jwt', now: now), isTrue);
      final noExp =
          'header.${base64Url.encode(utf8.encode(json.encode({'id': 'x'}))).replaceAll('=', '')}.sig';
      expect(AuthSession.isJwtExpired(noExp, now: now), isTrue);
    });
  });
}
