import 'package:dio/dio.dart';

class ActivityRequestModel {
  final String type;
  final String summary;
  final String details;
  final MultipartFile? image;

  ActivityRequestModel(
      {required this.type,
      required this.summary,
      required this.details,
      required this.image});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      "summary": summary,
      "details": details,
      "images": image,
    };
  }
}
