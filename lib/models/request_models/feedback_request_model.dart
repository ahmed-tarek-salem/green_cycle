import 'package:dio/dio.dart' as dio;

/// What a piece of feedback is about. The names are the server's values.
enum FeedbackType {
  app('التطبيق'),
  carpool('مشاركة السيارة'),
  other('أخرى');

  final String labelAr;

  const FeedbackType(this.labelAr);
}

/// A suggestion or note for `POST /feedback`. It earns no points.
class FeedbackRequestModel {
  final FeedbackType type;
  final String title;
  final String details;
  final dio.MultipartFile? image;

  FeedbackRequestModel({
    required this.type,
    required this.title,
    required this.details,
    this.image,
  });

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'title': title,
        'details': details,
        if (image != null) 'image': image,
      };
}

/// Turns the server's feedback errors into Arabic by their `code`. Anything
/// it does not recognise is returned as is.
String feedbackErrorMessage(String serverMessage, {String? code}) {
  switch (code) {
    case 'FEEDBACK_FIELDS_REQUIRED':
      return 'اكتب عنوان الملاحظة وتفاصيلها.';
    case 'INVALID_FEEDBACK_TYPE':
      return 'اختر نوع الملاحظة.';
    case 'INVALID_FEEDBACK_IMAGE':
      return 'الملف المرفق يجب أن يكون صورة.';
    case 'FEEDBACK_IMAGE_UPLOAD_FAILED':
      return 'تعذّر رفع الصورة. حاول مرة أخرى.';
  }
  return serverMessage;
}
