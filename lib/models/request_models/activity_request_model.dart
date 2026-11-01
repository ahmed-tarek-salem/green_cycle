import 'package:dio/dio.dart';

class ActivityRequestModel {
  final String type;
  final String summary;
  final String details;
  final MultipartFile? image;

  /// Rewards catalog slug. When set, the server takes the points and the
  /// cooldown from the catalog. Complaints leave it null.
  final String? rewardActionSlug;

  /// Chosen variant, for activities whose points depend on a variant.
  final String? variantKey;

  /// Quantity, for activities paid per unit.
  final int? units;

  ActivityRequestModel({
    required this.type,
    required this.summary,
    required this.details,
    required this.image,
    this.rewardActionSlug,
    this.variantKey,
    this.units,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      "summary": summary,
      "details": details,
      "images": image,
      if (rewardActionSlug != null) 'rewardActionSlug': rewardActionSlug,
      if (variantKey != null) 'variantKey': variantKey,
      if (units != null) 'units': units,
    };
  }
}
