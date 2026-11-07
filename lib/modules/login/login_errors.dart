/// Turns the server's login errors into Arabic. Anything it does not know
/// keeps the server's own message.
String loginErrorMessage(String? serverMessage, {String? code}) {
  if (code == 'ID_REJECTED') {
    // For this code the server sends the admin's rejection reason as the
    // message, and it may be empty.
    final reason = serverMessage?.trim() ?? '';
    final why = reason.isEmpty ? '' : '\nالسبب: $reason';
    return 'تم رفض صورة الكارنيه.$why\nمن فضلك سجّل حساباً جديداً وارفع صورة واضحة للكارنيه.';
  }
  return serverMessage ?? '';
}
