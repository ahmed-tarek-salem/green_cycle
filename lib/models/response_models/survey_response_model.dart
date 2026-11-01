class SurveyResponseModel {
  final String? id;
  final String? adminId;
  final String? title;
  final String? description;
  final List<Question>? questions;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  /// Whether the signed-in student already answered it. The server takes
  /// one answer per student.
  final bool answeredByMe;

  /// Points the student gets once for answering. Zero means none.
  final int rewardPoints;

  SurveyResponseModel({
    required this.id,
    required this.adminId,
    required this.title,
    required this.description,
    required this.questions,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.answeredByMe = false,
    this.rewardPoints = 0,
  });

  SurveyResponseModel markAnswered() => SurveyResponseModel(
        id: id,
        adminId: adminId,
        title: title,
        description: description,
        questions: questions,
        createdAt: createdAt,
        updatedAt: updatedAt,
        v: v,
        answeredByMe: true,
        rewardPoints: rewardPoints,
      );

  factory SurveyResponseModel.fromJson(Map<String, dynamic> json) =>
      SurveyResponseModel(
        answeredByMe: json["answeredByMe"] == true,
        rewardPoints: (json["rewardPoints"] as num?)?.toInt() ?? 0,
        id: json["_id"],
        adminId: json["adminId"],
        title: json["title"],
        description: json["description"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );
}

/// Turns the server's survey submit errors into Arabic by their `code`.
/// Anything it does not recognise is returned as is.
String surveySubmitErrorMessage(String serverMessage, {String? code}) {
  switch (code) {
    case 'ALREADY_ANSWERED':
      return 'أجبت على هذا الاستطلاع من قبل.';
  }
  return serverMessage;
}

class Question {
  final String? questionText;
  final String? questionType;
  final List<String>? options;
  final String? id;

  Question({
    required this.questionText,
    required this.questionType,
    required this.options,
    required this.id,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionText: json["questionText"],
        questionType: json["questionType"],
        options: List<String>.from(json["options"].map((x) => x)),
        id: json["_id"],
      );

  // Map<String, dynamic> toJson() => {
  //       "questionText": questionText,
  //       "questionType": questionType,
  //       "options": List<dynamic>.from(options.map((x) => x)),
  //       "_id": id,
  //     };
}
