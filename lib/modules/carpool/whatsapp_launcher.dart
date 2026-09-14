import 'package:url_launcher/url_launcher.dart';

class WhatsappLauncher {
  /// Builds the wa.me URI, appending an optional pre-filled `text` param.
  static Uri buildUri(String whatsappUrl, {String? message}) {
    if (message == null || message.isEmpty) return Uri.parse(whatsappUrl);
    final separator = whatsappUrl.contains('?') ? '&' : '?';
    return Uri.parse(
        '$whatsappUrl${separator}text=${Uri.encodeComponent(message)}');
  }

  /// Opens WhatsApp externally. Returns false if it could not be launched.
  static Future<bool> open(String whatsappUrl, {String? message}) async {
    final uri = buildUri(whatsappUrl, message: message);
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
