class SurveyResponseModel {
  final String? id;
  final String? adminId;
  final String? title;
  final String? description;
  final List<Question>? questions;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  SurveyResponseModel({
    required this.id,
    required this.adminId,
    required this.title,
    required this.description,
    required this.questions,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SurveyResponseModel.fromJson(Map<String, dynamic> json) =>
      SurveyResponseModel(
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
