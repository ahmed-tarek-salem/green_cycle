import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/my_activities_response_model.dart';

Map<String, dynamic> activityJson(Map<String, dynamic> extra) => {
      '_id': 'a1',
      'summary': 'زراعة شجرة',
      'createdAt': '2026-11-01T10:00:00.000Z',
      ...extra,
    };

void main() {
  test('reads a page of activities with their status', () {
    final page = MyActivitiesResponseModel.fromMap({
      'pagination': {'page': 1, 'limit': 20, 'total': 3, 'totalPages': 2},
      'data': {
        'activities': [
          activityJson({
            'status': 'pending',
            'proposedPoints': 50,
            'awardedPoints': null,
          }),
          activityJson({
            'status': 'approved',
            'proposedPoints': 50,
            'awardedPoints': 40,
          }),
          activityJson({
            'status': 'rejected',
            'rejectionReason': 'صورة غير واضحة',
          }),
        ],
      },
    });

    expect(page.activities.map((a) => a.status), [
      MyActivityStatus.pending,
      MyActivityStatus.approved,
      MyActivityStatus.rejected,
    ]);
    expect(page.activities[0].proposedPoints, 50);
    expect(page.activities[1].awardedPoints, 40);
    expect(page.activities[2].rejectionReason, 'صورة غير واضحة');
    expect(page.activities[0].title, 'زراعة شجرة');
    expect(page.hasMore, isTrue);
  });

  test('the last page has no more', () {
    final page = MyActivitiesResponseModel.fromMap({
      'pagination': {'page': 2, 'totalPages': 2},
      'data': {'activities': <dynamic>[]},
    });
    expect(page.hasMore, isFalse);
    expect(page.activities, isEmpty);
  });

  group('statusText', () {
    MyActivity activity(Map<String, dynamic> extra) =>
        MyActivity.fromMap(activityJson(extra));

    test('pending shows the proposed points', () {
      expect(
        activity({'status': 'pending', 'proposedPoints': 50}).statusText,
        'قيد المراجعة · ستحصل على 50 نقطة',
      );
    });

    test('approved shows the awarded points', () {
      expect(
        activity({'status': 'approved', 'awardedPoints': 40}).statusText,
        'تم القبول · حصلت على 40 نقطة',
      );
    });

    test('rejected shows the reason when there is one', () {
      expect(
        activity({'status': 'rejected', 'rejectionReason': 'صورة غير واضحة'})
            .statusText,
        'مرفوض · صورة غير واضحة',
      );
      expect(activity({'status': 'rejected'}).statusText, 'مرفوض');
    });

    test('no points shows the status alone', () {
      expect(activity({'status': 'pending'}).statusText, 'قيد المراجعة');
    });
  });
}
