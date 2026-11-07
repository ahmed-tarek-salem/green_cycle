import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';
import 'package:green_cycle/modules/rewards/rewards_texts.dart';

/// Longest note or link the server accepts with an activity.
const int activityNotesMaxLength = 500;

/// Points the server will propose for this submission. Shown as a preview
/// only. The server computes the real amount the same way.
int submissionPoints(RewardAction action, {String? variantKey, int units = 1}) {
  switch (action.pointsMode) {
    case PointsMode.variants:
      for (final variant in action.variants) {
        if (variant.key == variantKey) return variant.points;
      }
      return action.points;
    case PointsMode.perUnit:
      return action.points * (units < 1 ? 1 : units);
    case PointsMode.fixed:
      return action.points;
  }
}

/// The first problem with the form, in Arabic, or null when it can be sent.
String? validateSubmission({
  required RewardAction? action,
  required String? variantKey,
  required bool hasImage,
  required String details,
}) {
  if (action == null) return 'برجاء اختيار النشاط أولاً';
  final needsVariant =
      action.pointsMode == PointsMode.variants && action.variants.isNotEmpty;
  if (needsVariant && !action.variants.any((v) => v.key == variantKey)) {
    return 'برجاء اختيار النوع أولاً';
  }
  // The photo comes from the camera only, so it proves the activity is
  // happening now. The one way around it is a link, for activities that are
  // a post. A written description alone proves nothing.
  if (!hasImage && !containsLink(details)) {
    return 'برجاء التقاط صورة تثبت نشاطك، أو لصق رابط المنشور';
  }
  return null;
}

final _linkPattern = RegExp(
  r'(https?://\S+)|(www\.\S+)|(\b[a-z0-9-]+(\.[a-z0-9-]+)+/\S+)',
  caseSensitive: false,
);

/// Whether [text] has a pasted link: a full URL, a www address, or a domain
/// followed by a path. A bare domain does not count, since it points at no
/// post.
bool containsLink(String text) => _linkPattern.hasMatch(text);

bool _isCooldownError(String message, String? code) =>
    code == 'COOLDOWN' || message.toLowerCase().startsWith('you must wait');

bool isInactiveActionError(String message, {String? code}) =>
    code == 'ACTION_INACTIVE' ||
    message.toLowerCase().startsWith('reward action not found');

/// Turns the server's submit errors into Arabic, by their `code` and, for
/// servers that send no code, by the English message. Anything it does not
/// recognise is returned as is.
String submitErrorMessage(
  String serverMessage,
  RewardAction action, {
  String? code,
}) {
  if (_isCooldownError(serverMessage, code)) {
    final cooldown = cooldownText(action.cooldownDays);
    return cooldown == null
        ? 'لا يمكنك تكرار هذا النشاط الآن. حاول مرة أخرى لاحقاً.'
        : 'يمكنك رفع هذا النشاط $cooldown. حاول مرة أخرى لاحقاً.';
  }
  if (isInactiveActionError(serverMessage, code: code)) {
    return 'هذا النشاط لم يعد متاحاً حالياً.';
  }
  switch (code) {
    case 'PENDING_SAME_ACTION':
      return 'لديك طلب لنفس النشاط قيد المراجعة. يمكنك رفعه مرة أخرى بعد مراجعته.';
    case 'ACTION_NOT_STUDENT':
      return 'هذا النشاط تسجّله إدارة الكلية، ولا يمكن رفعه من التطبيق.';
    case 'MAX_UNITS_EXCEEDED':
      final max = RegExp(r'\d+').firstMatch(serverMessage)?.group(0);
      return max == null
          ? 'العدد أكبر من المسموح في الطلب الواحد.'
          : 'الحد الأقصى في الطلب الواحد $max ${action.unitLabelAr}.';
    case 'INVALID_VARIANT':
      return 'اختر نوع المشاركة أولاً.';
    case 'UPLOAD_FAILED':
      return 'تعذّر رفع الصورة. حاول مرة أخرى.';
    case 'VALIDATION_ERROR':
      if (serverMessage.contains('details cannot exceed')) {
        return 'الوصف طويل. الحد الأقصى $activityNotesMaxLength حرف.';
      }
      if (serverMessage.contains('at least one image')) {
        return 'أضف صورة أو وصفاً أو رابطاً للنشاط.';
      }
      return 'تأكد من البيانات وحاول مرة أخرى.';
  }
  return serverMessage;
}
