import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/about_us_response_model.dart';

void main() {
  test('reads the intro text and team members', () {
    final about = AboutUsResponseModel.fromMap({
      'data': {
        'aboutUs': [
          {
            'title': 'من نحن؟',
            'aboutUs': 'مبادرة طلابية',
            'members': [
              {
                'name': 'أحمد',
                'title': 'د/',
                'role': 'مشرف',
                'photo': 'https://x/a.png'
              },
              {'name': 'منى', 'title': '', 'role': '', 'photo': ''},
            ],
            'users': [],
          }
        ]
      }
    });

    expect(about.title, 'من نحن؟');
    expect(about.text, 'مبادرة طلابية');
    expect(about.members.length, 2);
    expect(about.members[0].displayName, 'د/ أحمد');
    expect(about.members[0].photo, 'https://x/a.png');
    expect(about.members[1].displayName, 'منى');
    expect(about.members[1].photo, isNull);
  });

  test('keeps legacy team entries and skips nameless ones', () {
    final about = AboutUsResponseModel.fromMap({
      'data': {
        'aboutUs': [
          {
            'aboutUs': 'نص',
            'users': [
              {
                'user': {'name': 'سارة', 'photo': 'https://x/s.png'},
                'title': 'Dr.',
                'role': 'منسقة'
              },
              {'title': 'Dr.'},
            ],
          }
        ]
      }
    });

    expect(about.members.length, 1);
    expect(about.members.single.displayName, 'Dr. سارة');
    expect(about.members.single.photo, 'https://x/s.png');
  });

  test('an empty response gives an empty page instead of failing', () {
    final about = AboutUsResponseModel.fromMap({
      'data': {'aboutUs': []}
    });
    expect(about.text, '');
    expect(about.members, isEmpty);
  });
}
