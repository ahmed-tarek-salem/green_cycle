import 'package:green_cycle/utilities/global/points_label.dart';

/// Something the student needs to see or answer, from
/// `GET /users/me/prompts`, oldest first.
sealed class AppPrompt {
  final String id;

  const AppPrompt(this.id);

  String get title;
  String get body;
}

/// Asked to both sides an hour after a carpool trip they arranged. Points are
/// given only when both say yes.
class CarpoolConfirmPrompt extends AppPrompt {
  final String tripId;
  final String date;
  final String time;
  final bool isDriver;
  final String? otherName;

  const CarpoolConfirmPrompt({
    required String id,
    required this.tripId,
    required this.date,
    required this.time,
    required this.isDriver,
    this.otherName,
  }) : super(id);

  @override
  String get title => 'هل تمت الرحلة؟';

  @override
  String get body {
    final name = otherName?.trim() ?? '';
    final when = 'يوم $date الساعة $time';
    if (isDriver) {
      return name.isEmpty
          ? 'هل ركب معك الراكب $when؟'
          : 'هل ركب معك $name $when؟';
    }
    return name.isEmpty ? 'هل ركبت مع السائق $when؟' : 'هل ركبت مع $name $when؟';
  }
}

/// Shown once after the admin accepts or rejects one of the student's
/// requests.
class ActivityReviewedPrompt extends AppPrompt {
  final String actionName;
  final bool approved;
  final int? awardedPoints;
  final String? reason;

  const ActivityReviewedPrompt({
    required String id,
    required this.actionName,
    required this.approved,
    this.awardedPoints,
    this.reason,
  }) : super(id);

  @override
  String get title => approved ? 'تم قبول طلبك' : 'لم يتم قبول طلبك';

  @override
  String get body {
    final prefix = actionName.isEmpty ? '' : '$actionName: ';
    if (approved) {
      final points = awardedPoints ?? 0;
      return points > 0
          ? '$prefixحصلت على ${pointsLabel(points)}.'
          : '$prefixتم قبول طلبك.';
    }
    final why = reason?.trim() ?? '';
    return why.isEmpty ? '$prefixيمكنك رفع طلب جديد.' : '$prefix$why';
  }
}

/// Prompts of types the app does not know yet are skipped.
List<AppPrompt> parsePrompts(Map<String, dynamic> map) {
  final data = map['data'] as Map<String, dynamic>? ?? const {};
  final items = data['prompts'];
  if (items is! List) return const [];
  return [
    for (final item in items)
      if (item is Map<String, dynamic>)
        if (_parse(item) case final prompt?) prompt,
  ];
}

AppPrompt? _parse(Map<String, dynamic> map) {
  final id = '${map['id'] ?? ''}';
  switch (map['type']) {
    case 'carpool_confirm':
      final other = map['otherUser'];
      return CarpoolConfirmPrompt(
        id: id,
        tripId: '${map['tripId'] ?? id}',
        date: '${map['date'] ?? ''}',
        time: '${map['time'] ?? ''}',
        isDriver: map['role'] == 'driver',
        otherName: other is Map ? other['name'] as String? : null,
      );
    case 'activity_reviewed':
      return ActivityReviewedPrompt(
        id: id,
        actionName: map['actionName'] ?? '',
        approved: map['status'] == 'approved',
        awardedPoints: (map['awardedPoints'] as num?)?.toInt(),
        reason: map['reason'],
      );
  }
  return null;
}

/// What the student sees after answering a carpool prompt.
String tripConfirmResultText({
  required bool rode,
  required bool awaitingOther,
  required int points,
}) {
  if (!rode) return 'تم تسجيل أن الرحلة لم تتم.';
  if (awaitingOther) {
    return 'تم تسجيل ردك. ستحصل على النقاط بعد تأكيد الطرف الآخر.';
  }
  return points > 0
      ? 'تم تأكيد الرحلة وحصلت على ${pointsLabel(points)}.'
      : 'تم تأكيد الرحلة.';
}
