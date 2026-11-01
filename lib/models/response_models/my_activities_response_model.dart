import 'package:green_cycle/utilities/global/points_label.dart';

/// One page of the student's own requests from `GET /activities/me`, newest
/// first. Welcome, redeem and admin entries are left out by the server.
class MyActivitiesResponseModel {
  final List<MyActivity> activities;
  final int page;
  final int totalPages;

  const MyActivitiesResponseModel({
    required this.activities,
    required this.page,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;

  factory MyActivitiesResponseModel.fromMap(Map<String, dynamic> map) {
    final data = map['data'] as Map<String, dynamic>? ?? const {};
    final pagination = map['pagination'] as Map<String, dynamic>? ?? const {};
    final items = data['activities'];
    return MyActivitiesResponseModel(
      activities: [
        if (items is List)
          for (final item in items)
            if (item is Map<String, dynamic>) MyActivity.fromMap(item),
      ],
      page: _toInt(pagination['page'], fallback: 1),
      totalPages: _toInt(pagination['totalPages'], fallback: 1),
    );
  }
}

enum MyActivityStatus { pending, approved, rejected }

class MyActivity {
  final String id;
  final String title;
  final MyActivityStatus status;

  /// What the server proposed when the request was sent.
  final int? proposedPoints;

  /// What the admin actually gave. Set once approved.
  final int? awardedPoints;
  final String? rejectionReason;
  final DateTime? createdAt;

  const MyActivity({
    required this.id,
    required this.title,
    required this.status,
    this.proposedPoints,
    this.awardedPoints,
    this.rejectionReason,
    this.createdAt,
  });

  factory MyActivity.fromMap(Map<String, dynamic> map) {
    return MyActivity(
      id: '${map['_id'] ?? map['id'] ?? ''}',
      title: map['summary'] ?? '',
      status: switch (map['status']) {
        'approved' => MyActivityStatus.approved,
        'rejected' => MyActivityStatus.rejected,
        _ => MyActivityStatus.pending,
      },
      proposedPoints: (map['proposedPoints'] as num?)?.toInt(),
      awardedPoints: (map['awardedPoints'] as num?)?.toInt(),
      rejectionReason: map['rejectionReason'],
      createdAt: DateTime.tryParse('${map['createdAt']}')?.toLocal(),
    );
  }

  /// The status in a short Arabic line, with the points or the reason.
  String get statusText {
    switch (status) {
      case MyActivityStatus.pending:
        final points = proposedPoints ?? 0;
        return points > 0
            ? 'قيد المراجعة · ستحصل على ${pointsLabel(points)}'
            : 'قيد المراجعة';
      case MyActivityStatus.approved:
        final points = awardedPoints ?? proposedPoints ?? 0;
        return points > 0
            ? 'تم القبول · حصلت على ${pointsLabel(points)}'
            : 'تم القبول';
      case MyActivityStatus.rejected:
        final reason = rejectionReason?.trim() ?? '';
        return reason.isEmpty ? 'مرفوض' : 'مرفوض · $reason';
    }
  }
}

int _toInt(Object? value, {required int fallback}) =>
    value is num ? value.toInt() : fallback;
