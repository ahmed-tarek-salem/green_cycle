import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:green_cycle/models/response_models/question_response_model.dart';

class FaqResponseModel {
  List<QuestionResponseModel> questions;
  FaqResponseModel({
    required this.questions,
  });

  factory FaqResponseModel.fromMap(Map<String, dynamic> map) {
    return FaqResponseModel(
      questions: List<QuestionResponseModel>.from(map['data']['FAQs']
          .map((question) => QuestionResponseModel.fromMap(question))),
    );
  }
}
