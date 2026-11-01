class SurveyRequestModel {
  final String questionnaireId;

  // TODO: drop studentId once the backend takes the student from the token
  // (Trello "P1 · الإجابة على الاستطلاع باسم طالب تاني",
  // https://trello.com/c/5DimQIAa). Then remove it here, in toJson, and the
  // lookup in SurveyDetailsController.submitSurvey.
  final String studentId;
  final List<QuestionResponse> responses;

  SurveyRequestModel({
    required this.questionnaireId,
    required this.studentId,
    required this.responses,
  });

  Map<String, dynamic> toJson() => {
        "questionnaireId": questionnaireId,
        "studentId": studentId,
        "responses": List<dynamic>.from(responses.map((x) => x.toJson())),
      };
}

class QuestionResponse {
  final int questionIndex;
  final String? answer;

  QuestionResponse({
    required this.questionIndex,
    required this.answer,
  });

  factory QuestionResponse.fromJson(Map<String, dynamic> json) =>
      QuestionResponse(
        questionIndex: json["questionIndex"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "questionIndex": questionIndex,
        "answer": answer,
      };

  QuestionResponse copyWith({
    int? questionIndex,
    String? answer,
  }) {
    return QuestionResponse(
      questionIndex: questionIndex ?? this.questionIndex,
      answer: answer ?? this.answer,
    );
  }

  @override
  String toString() =>
      'QuestionResponse(questionIndex: $questionIndex, answer: $answer)';
}
