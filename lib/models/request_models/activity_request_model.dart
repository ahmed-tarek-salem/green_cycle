import 'package:dio/dio.dart';

class ActivityRequestModel {
  final String type;
  final String summary;
  final String details;
  final int? points;
  final MultipartFile? image;

  ActivityRequestModel(
      {required this.type,
      required this.summary,
      required this.details,
      required this.points,
      required this.image});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      "summary": summary,
      "details": details,
      "points": points,
      "images": image,
    };
  }
}
