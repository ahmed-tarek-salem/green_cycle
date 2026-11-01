import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/request_models/feedback_request_model.dart';

void main() {
  group('FeedbackRequestModel.toMap', () {
    test('sends the type, title and details', () {
      final map = FeedbackRequestModel(
        type: FeedbackType.carpool,
        title: 'السواق اتأخر',
        details: 'التفاصيل',
      ).toMap();

      expect(map, {
        'type': 'carpool',
        'title': 'السواق اتأخر',
        'details': 'التفاصيل',
      });
    });
  });

  test('every type has an Arabic label', () {
    expect(FeedbackType.values.map((t) => t.labelAr), [
      'التطبيق',
      'مشاركة السيارة',
      'أخرى',
    ]);
  });

  group('feedbackErrorMessage', () {
    test('explains the server codes in Arabic', () {
      expect(
        feedbackErrorMessage('x', code: 'FEEDBACK_FIELDS_REQUIRED'),
        'اكتب عنوان الملاحظة وتفاصيلها.',
      );
      expect(
        feedbackErrorMessage('x', code: 'INVALID_FEEDBACK_TYPE'),
        'اختر نوع الملاحظة.',
      );
      expect(
        feedbackErrorMessage('x', code: 'INVALID_FEEDBACK_IMAGE'),
        'الملف المرفق يجب أن يكون صورة.',
      );
      expect(
        feedbackErrorMessage('x', code: 'FEEDBACK_IMAGE_UPLOAD_FAILED'),
        'تعذّر رفع الصورة. حاول مرة أخرى.',
      );
    });

    test('passes other messages through', () {
      expect(feedbackErrorMessage('حدث خطأ'), 'حدث خطأ');
    });
  });
}
