import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';
import 'package:green_cycle/modules/action/activity_submission.dart';

import '../rewards/rewards_fixture.dart';

void main() {
  final catalog = RewardsCatalogResponseModel.fromMap(rewardsCatalogJson());
  final recycle = catalog.actions[0]; // fixed, 20, cooldown 7
  final social = catalog.actions[1]; // variants 25 / 50 / 100
  final clothes = catalog.actions[2]; // per unit, 50 each

  group('submissionPoints', () {
    test('fixed ignores variant and units', () {
      expect(submissionPoints(recycle, variantKey: 'x', units: 9), 20);
    });

    test('variants use the chosen variant', () {
      expect(submissionPoints(social, variantKey: 'reel'), 50);
      expect(submissionPoints(social, variantKey: 'video'), 100);
    });

    test('variants without a choice fall back to the base amount', () {
      expect(submissionPoints(social), 25);
    });

    test('per unit multiplies, and never by less than one', () {
      expect(submissionPoints(clothes, units: 3), 150);
      expect(submissionPoints(clothes, units: 0), 50);
    });
  });

  group('validateSubmission', () {
    test('needs an activity first', () {
      expect(
        validateSubmission(
          action: null,
          variantKey: null,
          hasImage: true,
          details: '',
        ),
        'برجاء اختيار النشاط أولاً',
      );
    });

    test('needs a variant when the activity has variants', () {
      expect(
        validateSubmission(
          action: social,
          variantKey: null,
          hasImage: true,
          details: '',
        ),
        'برجاء اختيار النوع أولاً',
      );
      expect(
        validateSubmission(
          action: social,
          variantKey: 'nope',
          hasImage: true,
          details: '',
        ),
        'برجاء اختيار النوع أولاً',
      );
    });

    test('needs a live photo, and a written description is not enough', () {
      const message = 'برجاء التقاط صورة تثبت نشاطك، أو لصق رابط المنشور';
      expect(
        validateSubmission(
          action: recycle,
          variantKey: null,
          hasImage: false,
          details: '  ',
        ),
        message,
      );
      expect(
        validateSubmission(
          action: recycle,
          variantKey: null,
          hasImage: false,
          details: 'سلمت 3 كيلو بلاستيك النهاردة',
        ),
        message,
      );
    });

    test('accepts a photo alone', () {
      expect(
        validateSubmission(
          action: recycle,
          variantKey: null,
          hasImage: true,
          details: '',
        ),
        isNull,
      );
    });

    test('accepts a link instead of a photo, for posts', () {
      expect(
        validateSubmission(
          action: social,
          variantKey: 'post',
          hasImage: false,
          details: 'المنشور: https://www.instagram.com/p/abc123/',
        ),
        isNull,
      );
    });
  });

  group('containsLink', () {
    test('recognises pasted links', () {
      expect(containsLink('https://www.instagram.com/reel/abc/'), isTrue);
      expect(containsLink('http://fb.watch/xyz'), isTrue);
      expect(containsLink('شوف هنا www.tiktok.com/@user/video/1'), isTrue);
      expect(containsLink('facebook.com/groups/pharmacy/posts/9'), isTrue);
      expect(containsLink('youtu.be/abc123'), isTrue);
    });

    test('ignores plain descriptions', () {
      expect(containsLink(''), isFalse);
      expect(containsLink('سلمت 3.5 كيلو ورق'), isFalse);
      expect(containsLink('نشرت بوست على انستجرام'), isFalse);
      expect(containsLink('instagram.com'), isFalse);
      expect(containsLink('a.b'), isFalse);
    });
  });

  group('submitErrorMessage', () {
    test('explains the cooldown in Arabic using the catalog', () {
      expect(
        submitErrorMessage(
          'you must wait 7 days until you can create another recycle-dropoff activity.',
          recycle,
        ),
        'يمكنك رفع هذا النشاط مرة واحدة كل 7 أيام. حاول مرة أخرى لاحقاً.',
      );
    });

    test('still explains the cooldown if the catalog says there is none', () {
      expect(
        submitErrorMessage('you must wait 3 days until ...', clothes),
        'لا يمكنك تكرار هذا النشاط الآن. حاول مرة أخرى لاحقاً.',
      );
    });

    test('explains a removed activity', () {
      expect(
        submitErrorMessage('Reward action not found or inactive.', recycle),
        'هذا النشاط لم يعد متاحاً حالياً.',
      );
      expect(
        isInactiveActionError('Reward action not found or inactive.'),
        isTrue,
      );
      expect(isInactiveActionError('anything else'), isFalse);
    });

    test('passes other messages through', () {
      expect(submitErrorMessage('حدث خطأ', recycle), 'حدث خطأ');
    });

    test('explains the server error codes in Arabic', () {
      String byCode(String code, [String message = 'English text']) =>
          submitErrorMessage(message, recycle, code: code);

      expect(
        byCode('PENDING_SAME_ACTION'),
        'لديك طلب لنفس النشاط قيد المراجعة. يمكنك رفعه مرة أخرى بعد مراجعته.',
      );
      expect(
        byCode('COOLDOWN'),
        'يمكنك رفع هذا النشاط مرة واحدة كل 7 أيام. حاول مرة أخرى لاحقاً.',
      );
      expect(byCode('ACTION_INACTIVE'), 'هذا النشاط لم يعد متاحاً حالياً.');
      expect(
        byCode('ACTION_NOT_STUDENT'),
        'هذا النشاط تسجّله إدارة الكلية، ولا يمكن رفعه من التطبيق.',
      );
      expect(
        submitErrorMessage(
          'units cannot exceed 10 for this activity.',
          clothes,
          code: 'MAX_UNITS_EXCEEDED',
        ),
        'الحد الأقصى في الطلب الواحد 10 قطعة.',
      );
      expect(
        byCode('MAX_UNITS_EXCEEDED', 'no number here'),
        'العدد أكبر من المسموح في الطلب الواحد.',
      );
      expect(byCode('INVALID_VARIANT'), 'اختر نوع المشاركة أولاً.');
      expect(byCode('UPLOAD_FAILED'), 'تعذّر رفع الصورة. حاول مرة أخرى.');
    });

    test('falls back to a generic Arabic message for unknown codes', () {
      expect(
        submitErrorMessage('Something broke', recycle, code: 'SOMETHING_NEW'),
        'Something broke',
      );
      expect(
        submitErrorMessage('bad input', recycle, code: 'VALIDATION_ERROR'),
        'تأكد من البيانات وحاول مرة أخرى.',
      );
    });

    test('knows the inactive error by its code too', () {
      expect(isInactiveActionError('x', code: 'ACTION_INACTIVE'), isTrue);
    });
  });
}
