class QuestionResponseModel {
  final String id;
  final String question;
  final String answer;

  QuestionResponseModel({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory QuestionResponseModel.fromMap(Map<String, dynamic> map) {
    return QuestionResponseModel(
      id: map['_id'],
      question: map['question'],
      answer: map['answer'],
    );
  }
}
