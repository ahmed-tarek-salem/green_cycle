import 'package:green_cycle/models/response_models/carpool_offer_response_model.dart';

class CheckpointInput {
  final String district; // district ObjectId
  final int order;

  const CheckpointInput({required this.district, required this.order});

  Map<String, dynamic> toMap() => {'district': district, 'order': order};
}

class SetupOfferRequest {
  final List<WeeklyScheduleEntry> weeklySchedule;
  final List<CheckpointInput> checkpoints;
  final String? destinationNameEn;
  final String? destinationNameAr;
  final String? notes;

  SetupOfferRequest({
    required this.weeklySchedule,
    required this.checkpoints,
    this.destinationNameEn,
    this.destinationNameAr,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'weeklySchedule': weeklySchedule.map((e) => e.toMap()).toList(),
      'checkpoints': checkpoints.map((e) => e.toMap()).toList(),
    };
    if (destinationNameEn != null) map['destinationNameEn'] = destinationNameEn;
    if (destinationNameAr != null) map['destinationNameAr'] = destinationNameAr;
    if (notes != null && notes!.trim().isNotEmpty) map['notes'] = notes!.trim();
    return map;
  }
}
