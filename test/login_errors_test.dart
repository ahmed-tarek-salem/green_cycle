import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/modules/login/login_errors.dart';

void main() {
  test('a rejected ID shows the reason and asks to sign up again', () {
    final text = loginErrorMessage('صورة غير واضحة', code: 'ID_REJECTED');
    expect(text, contains('تم رفض صورة الكارنيه'));
    expect(text, contains('السبب: صورة غير واضحة'));
    expect(text, contains('سجّل حساباً جديداً'));
  });

  test('a rejected ID without a reason still asks to sign up again', () {
    final text = loginErrorMessage(null, code: 'ID_REJECTED');
    expect(text, isNot(contains('السبب')));
    expect(text, contains('سجّل حساباً جديداً'));
  });

  test('other errors keep the server message', () {
    expect(
        loginErrorMessage('Invalid phone or Password!',
            code: 'INVALID_CREDENTIALS'),
        'Invalid phone or Password!');
  });
}
