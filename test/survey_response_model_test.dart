import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/survey_response_model.dart';

Map<String, dynamic> surveyJson([Map<String, dynamic> extra = const {}]) => {
      '_id': 's1',
      'adminId': 'a1',
      'title': 'استطلاع',
      'questions': [
        {
          '_id': 'q1',
          'questionText': 'سؤال؟',
          'questionType': 'mcq',
          'options': ['آه', 'لأ'],
        },
      ],
      '__v': 0,
      ...extra,
    };

void main() {
  test('reads whether the student answered and the reward', () {
    final survey = SurveyResponseModel.fromJson(
      surveyJson({'answeredByMe': true, 'rewardPoints': 10}),
    );
    expect(survey.answeredByMe, isTrue);
    expect(survey.rewardPoints, 10);
  });

  test('older servers send neither field', () {
    final survey = SurveyResponseModel.fromJson(surveyJson());
    expect(survey.answeredByMe, isFalse);
    expect(survey.rewardPoints, 0);
  });

  test('marking a survey answered keeps everything else', () {
    final survey = SurveyResponseModel.fromJson(
      surveyJson({'rewardPoints': 10}),
    ).markAnswered();
    expect(survey.answeredByMe, isTrue);
    expect(survey.title, 'استطلاع');
    expect(survey.rewardPoints, 10);
    expect(survey.questions?.length, 1);
  });

  group('surveySubmitErrorMessage', () {
    test('explains a second answer in Arabic', () {
      expect(
        surveySubmitErrorMessage('x', code: 'ALREADY_ANSWERED'),
        'أجبت على هذا الاستطلاع من قبل.',
      );
    });

    test('passes other messages through', () {
      expect(surveySubmitErrorMessage('حدث خطأ'), 'حدث خطأ');
    });
  });
}
