# Carpooling Feature Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a carpooling section (driver offers + passenger search + WhatsApp contact) to the green_cycle Flutter app, integrating the already-live `carpool/*` backend routes.

**Architecture:** A new route-reached module `lib/modules/carpool/` mirroring the `tabs/streak_board` convention (`_repo` / `_controller` / screen + `widgets/`). A stateless `CarpoolRepo` owns all endpoints and an in-memory district cache; a shared `CarpoolController` (registered `fenix`) holds districts + my-offer state; two sub-controllers drive the driver wizard and passenger search. Public endpoints use `DioClient.publicDio`, protected ones use `DioClient.privateDio` (existing cookie-JWT). Arabic-only UI.

**Tech Stack:** Flutter, GetX (controllers/routing/DI), Dio, flutter_screenutil, url_launcher, flutter_test.

**Spec:** `docs/superpowers/specs/2026-07-12-carpooling-design.md`

---

## Working notes (read before starting)

- **No git worktree.** Work directly in the main checkout (user rule).
- **Commits need explicit approval.** Each task ends with a commit step; per the user's git protocol, **do not run `git commit` without the user explicitly approving that commit first** (show staged files + message, wait for "yes"). Never push unless separately asked.
- **Flutter binary:** if `flutter` isn't on PATH, use `/Users/ahmedtareksalem/fvm/default/bin/flutter`.
- **Testing approach:** pure logic (models, parsing, formatting, URL building) is built **TDD** with `flutter test`. Controllers/screens have no widget tests (the codebase has none and relies on manual runs) — they're verified by `flutter analyze` + running the app and exercising the flow. This is deliberate, not an omission.
- **Login for manual verification:** the app auto-logs-in if a valid token is stored; otherwise log in via the app first. Protected carpool calls reuse that session.

---

## Task 0: Verify cookie-JWT works on protected carpool routes

**Files:** none (verification only).

- [ ] **Step 1: Get a fresh token**

Run the app, log in, and copy the `Cookie: JWT=...` value from the Dio request log (or reuse a known-valid token).

- [ ] **Step 2: Call a protected carpool endpoint with the cookie**

Run (replace `<JWT>`):

```bash
curl -s -o /dev/null -w "%{http_code}\n" \
  -H "Cookie: JWT=<JWT>" \
  https://green-cycle-juiq.onrender.com/api/v1/carpool/offers/me
```

Expected: `200` (with `{"status":"success","data":{"offer":...|null}}`).

- [ ] **Step 3: Decide**

- `200` → cookie-JWT works; proceed as planned.
- `401` with "not logged in" → the carpool routes need `Authorization: Bearer`. Before Task 4, add `privateDio.options.headers['Authorization'] = 'Bearer $token'` in `DioClient.login()` alongside the cookie. Note this in the task and continue.

No commit (no code change).

---

## Task 1: Endpoints, District model, and carpool utils

**Files:**
- Modify: `lib/utilities/global/app_endpoints.dart`
- Create: `lib/models/response_models/district_response_model.dart`
- Create: `lib/modules/carpool/carpool_utils.dart`
- Create: `lib/modules/carpool/whatsapp_launcher.dart`
- Test: `test/carpool/carpool_foundation_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/carpool/carpool_foundation_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/response_models/district_response_model.dart';
import 'package:green_cycle/modules/carpool/carpool_utils.dart';
import 'package:green_cycle/modules/carpool/whatsapp_launcher.dart';

void main() {
  test('DistrictsResponseModel parses the districts envelope', () {
    final model = DistrictsResponseModel.fromMap({
      'status': 'success',
      'results': 2,
      'data': {
        'districts': [
          {'_id': 'a1', 'nameEn': 'Smouha', 'nameAr': 'سموحة'},
          {'_id': 'a2', 'nameEn': 'Sidi Bishr', 'nameAr': 'سيدي بشر'},
        ]
      }
    });
    expect(model.districts.length, 2);
    expect(model.districts.first.id, 'a1');
    expect(model.districts.first.nameAr, 'سموحة');
  });

  test('DistrictsResponseModel tolerates a missing districts list', () {
    expect(DistrictsResponseModel.fromMap({'data': {}}).districts, isEmpty);
  });

  test('CarpoolDays maps API values to Arabic labels', () {
    expect(CarpoolDays.all.length, 7);
    expect(CarpoolDays.label('sunday'), 'الأحد');
    expect(CarpoolDays.label('friday'), 'الجمعة');
    expect(CarpoolDays.label('unknown'), 'unknown');
  });

  test('formatTimeOfDay zero-pads to HH:MM', () {
    expect(formatTimeOfDay(const TimeOfDay(hour: 8, minute: 0)), '08:00');
    expect(formatTimeOfDay(const TimeOfDay(hour: 14, minute: 30)), '14:30');
  });

  test('WhatsappLauncher.buildUri appends an encoded text param', () {
    final plain = WhatsappLauncher.buildUri('https://wa.me/201012345678');
    expect(plain.toString(), 'https://wa.me/201012345678');

    final withMsg = WhatsappLauncher.buildUri('https://wa.me/201012345678', message: 'مرحبا');
    expect(withMsg.toString(), contains('wa.me/201012345678?text='));
    expect(withMsg.queryParameters['text'], 'مرحبا');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/carpool/carpool_foundation_test.dart`
Expected: FAIL — target files don't exist yet.

- [ ] **Step 3: Add endpoint constants**

In `lib/utilities/global/app_endpoints.dart`, add before the closing brace:

```dart
  static const carpoolDistricts = '${baseUrl}carpool/districts';
  static const carpoolDays = '${baseUrl}carpool/days';
  static const carpoolOfferMe = '${baseUrl}carpool/offers/me';
  static const carpoolSearch = '${baseUrl}carpool/offers/search';
  static String carpoolContact(String offerId) =>
      '${baseUrl}carpool/offers/$offerId/contact';
```

- [ ] **Step 4: Create the District model**

Create `lib/models/response_models/district_response_model.dart`:

```dart
class District {
  final String id;
  final String nameEn;
  final String nameAr;

  const District({required this.id, required this.nameEn, required this.nameAr});

  factory District.fromMap(Map<String, dynamic> map) => District(
        id: map['_id'] ?? '',
        nameEn: map['nameEn'] ?? '',
        nameAr: map['nameAr'] ?? '',
      );
}

class DistrictsResponseModel {
  final List<District> districts;

  DistrictsResponseModel({required this.districts});

  factory DistrictsResponseModel.fromMap(Map<String, dynamic> map) {
    final list = (map['data']?['districts'] as List?) ?? const [];
    return DistrictsResponseModel(
      districts: list
          .map((e) => District.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
```

- [ ] **Step 5: Create carpool_utils**

Create `lib/modules/carpool/carpool_utils.dart`:

```dart
import 'package:flutter/material.dart';

/// Default carpool destination (Faculty of Pharmacy, Alexandria University).
const String kCarpoolDestinationAr = 'كلية الصيدلة - جامعة الإسكندرية';
const String kCarpoolDestinationEn = 'Faculty of Pharmacy, Alexandria University';

class CarpoolDays {
  static const List<String> all = [
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
  ];

  static const Map<String, String> _ar = {
    'sunday': 'الأحد',
    'monday': 'الإثنين',
    'tuesday': 'الثلاثاء',
    'wednesday': 'الأربعاء',
    'thursday': 'الخميس',
    'friday': 'الجمعة',
    'saturday': 'السبت',
  };

  static String label(String day) => _ar[day] ?? day;
}

/// 24-hour, zero-padded "HH:MM" (e.g. 08:00, 14:30).
String formatTimeOfDay(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

/// Parse an "HH:MM" string back into a TimeOfDay (for edit prefill). Returns
/// 08:00 if the string is malformed.
TimeOfDay parseHHmm(String value) {
  final parts = value.split(':');
  if (parts.length != 2) return const TimeOfDay(hour: 8, minute: 0);
  final h = int.tryParse(parts[0]) ?? 8;
  final m = int.tryParse(parts[1]) ?? 0;
  return TimeOfDay(hour: h.clamp(0, 23), minute: m.clamp(0, 59));
}
```

- [ ] **Step 6: Create whatsapp_launcher**

Create `lib/modules/carpool/whatsapp_launcher.dart`:

```dart
import 'package:url_launcher/url_launcher.dart';

class WhatsappLauncher {
  /// Builds the wa.me URI, appending an optional pre-filled `text` param.
  static Uri buildUri(String whatsappUrl, {String? message}) {
    if (message == null || message.isEmpty) return Uri.parse(whatsappUrl);
    final separator = whatsappUrl.contains('?') ? '&' : '?';
    return Uri.parse(
        '$whatsappUrl${separator}text=${Uri.encodeComponent(message)}');
  }

  /// Opens WhatsApp externally. Returns false if it could not be launched.
  static Future<bool> open(String whatsappUrl, {String? message}) async {
    final uri = buildUri(whatsappUrl, message: message);
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
```

- [ ] **Step 7: Run tests to verify they pass**

Run: `flutter test test/carpool/carpool_foundation_test.dart`
Expected: PASS (5 tests).

- [ ] **Step 8: Commit** (request approval first)

```bash
git add lib/utilities/global/app_endpoints.dart lib/models/response_models/district_response_model.dart lib/modules/carpool/carpool_utils.dart lib/modules/carpool/whatsapp_launcher.dart test/carpool/carpool_foundation_test.dart
git commit -m "feat(carpool): add endpoints, district model, and utils"
```

---

## Task 2: Offer models and setup request

**Files:**
- Create: `lib/models/response_models/carpool_offer_response_model.dart`
- Create: `lib/models/request_models/setup_offer_request_model.dart`
- Test: `test/carpool/offer_model_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/carpool/offer_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/request_models/setup_offer_request_model.dart';
import 'package:green_cycle/models/response_models/carpool_offer_response_model.dart';

void main() {
  final offerJson = {
    'status': 'success',
    'data': {
      'offer': {
        '_id': 'offer1',
        'driver': {
          '_id': 'drv1',
          'name': 'Ahmed',
          'phone': 1012345678,
          'avatar': 'http://a/x.jpg',
          'gender': 'male',
        },
        'destinationNameEn': 'Faculty of Pharmacy, Alexandria University',
        'destinationNameAr': 'كلية الصيدلة - جامعة الإسكندرية',
        'weeklySchedule': [
          {'dayOfWeek': 'sunday', 'arrivalTime': '08:00', 'active': true},
          {'dayOfWeek': 'tuesday', 'arrivalTime': '08:30', 'active': true},
        ],
        'checkpoints': [
          {'district': {'_id': 'd2', 'nameEn': 'Smouha', 'nameAr': 'سموحة'}, 'order': 1},
          {'district': {'_id': 'd1', 'nameEn': 'Sidi Bishr', 'nameAr': 'سيدي بشر'}, 'order': 0},
        ],
        'isActive': true,
        'notes': '2 seats',
      }
    }
  };

  test('OfferResponseModel parses a populated offer', () {
    final offer = OfferResponseModel.fromMap(offerJson).offer!;
    expect(offer.id, 'offer1');
    expect(offer.driver.name, 'Ahmed');
    expect(offer.driver.phone, 1012345678);
    expect(offer.isActive, isTrue);
    expect(offer.weeklySchedule.length, 2);
  });

  test('checkpoints are sorted by order ascending', () {
    final offer = OfferResponseModel.fromMap(offerJson).offer!;
    expect(offer.checkpoints.map((c) => c.district.id).toList(), ['d1', 'd2']);
  });

  test('OfferResponseModel handles offer: null', () {
    final model = OfferResponseModel.fromMap({'data': {'offer': null}});
    expect(model.offer, isNull);
  });

  test('SetupOfferRequest.toMap sends checkpoints with the district alias', () {
    final req = SetupOfferRequest(
      weeklySchedule: const [
        WeeklyScheduleEntry(dayOfWeek: 'sunday', arrivalTime: '08:00'),
      ],
      checkpoints: const [
        CheckpointInput(district: 'd1', order: 0),
        CheckpointInput(district: 'd2', order: 1),
      ],
      notes: 'hi',
    );
    final map = req.toMap();
    expect(map['weeklySchedule'][0]['arrivalTime'], '08:00');
    expect(map['weeklySchedule'][0]['active'], true);
    expect(map['checkpoints'][1], {'district': 'd2', 'order': 1});
    expect(map['notes'], 'hi');
    expect(map.containsKey('destinationNameEn'), isFalse);
  });

  test('SetupOfferRequest.toMap omits empty notes', () {
    final req = SetupOfferRequest(
      weeklySchedule: const [WeeklyScheduleEntry(dayOfWeek: 'sunday', arrivalTime: '08:00')],
      checkpoints: const [CheckpointInput(district: 'd1', order: 0)],
    );
    expect(req.toMap().containsKey('notes'), isFalse);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/carpool/offer_model_test.dart`
Expected: FAIL — models don't exist yet.

- [ ] **Step 3: Create the offer response models**

Create `lib/models/response_models/carpool_offer_response_model.dart`:

```dart
import 'package:green_cycle/models/response_models/district_response_model.dart';

class WeeklyScheduleEntry {
  final String dayOfWeek;
  final String arrivalTime; // "HH:MM"
  final bool active;

  const WeeklyScheduleEntry({
    required this.dayOfWeek,
    required this.arrivalTime,
    this.active = true,
  });

  factory WeeklyScheduleEntry.fromMap(Map<String, dynamic> map) =>
      WeeklyScheduleEntry(
        dayOfWeek: map['dayOfWeek'] ?? '',
        arrivalTime: map['arrivalTime'] ?? '',
        active: map['active'] ?? true,
      );

  Map<String, dynamic> toMap() =>
      {'dayOfWeek': dayOfWeek, 'arrivalTime': arrivalTime, 'active': active};
}

class Checkpoint {
  final District district;
  final int order;

  const Checkpoint({required this.district, required this.order});

  factory Checkpoint.fromMap(Map<String, dynamic> map) => Checkpoint(
        district:
            District.fromMap((map['district'] as Map<String, dynamic>?) ?? const {}),
        order: map['order'] ?? 0,
      );
}

class CarpoolDriverSummary {
  final String id;
  final String name;
  final String avatar;
  final String gender;
  final int? phone;

  const CarpoolDriverSummary({
    required this.id,
    required this.name,
    required this.avatar,
    required this.gender,
    this.phone,
  });

  factory CarpoolDriverSummary.fromMap(Map<String, dynamic> map) =>
      CarpoolDriverSummary(
        id: map['_id'] ?? '',
        name: map['name'] ?? '',
        avatar: map['avatar'] ?? '',
        gender: map['gender'] ?? '',
        phone: map['phone'],
      );
}

/// Sorts a raw checkpoints list by `order` and maps to [Checkpoint].
List<Checkpoint> parseCheckpoints(List? raw) {
  final list = (raw ?? const [])
      .map((e) => Checkpoint.fromMap(e as Map<String, dynamic>))
      .toList()
    ..sort((a, b) => a.order.compareTo(b.order));
  return list;
}

class CarpoolOffer {
  final String id;
  final CarpoolDriverSummary driver;
  final String destinationNameEn;
  final String destinationNameAr;
  final List<WeeklyScheduleEntry> weeklySchedule;
  final List<Checkpoint> checkpoints;
  final bool isActive;
  final String? notes;

  CarpoolOffer({
    required this.id,
    required this.driver,
    required this.destinationNameEn,
    required this.destinationNameAr,
    required this.weeklySchedule,
    required this.checkpoints,
    required this.isActive,
    this.notes,
  });

  factory CarpoolOffer.fromMap(Map<String, dynamic> map) => CarpoolOffer(
        id: map['_id'] ?? '',
        driver: CarpoolDriverSummary.fromMap(
            (map['driver'] as Map<String, dynamic>?) ?? const {}),
        destinationNameEn: map['destinationNameEn'] ?? '',
        destinationNameAr: map['destinationNameAr'] ?? '',
        weeklySchedule: ((map['weeklySchedule'] as List?) ?? const [])
            .map((e) => WeeklyScheduleEntry.fromMap(e as Map<String, dynamic>))
            .toList(),
        checkpoints: parseCheckpoints(map['checkpoints'] as List?),
        isActive: map['isActive'] ?? true,
        notes: map['notes'],
      );
}

class OfferResponseModel {
  final CarpoolOffer? offer;

  OfferResponseModel({required this.offer});

  factory OfferResponseModel.fromMap(Map<String, dynamic> map) {
    final raw = map['data']?['offer'];
    return OfferResponseModel(
      offer: raw == null ? null : CarpoolOffer.fromMap(raw as Map<String, dynamic>),
    );
  }
}
```

- [ ] **Step 4: Create the setup request model**

Create `lib/models/request_models/setup_offer_request_model.dart`:

```dart
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
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/carpool/offer_model_test.dart`
Expected: PASS (5 tests).

- [ ] **Step 6: Commit** (request approval first)

```bash
git add lib/models/response_models/carpool_offer_response_model.dart lib/models/request_models/setup_offer_request_model.dart test/carpool/offer_model_test.dart
git commit -m "feat(carpool): add offer models and setup request"
```

---

## Task 3: Search and contact models

**Files:**
- Create: `lib/models/response_models/carpool_search_response_model.dart`
- Create: `lib/models/response_models/contact_driver_response_model.dart`
- Create: `lib/models/request_models/contact_driver_request_model.dart`
- Test: `test/carpool/search_contact_model_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/carpool/search_contact_model_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:green_cycle/models/request_models/contact_driver_request_model.dart';
import 'package:green_cycle/models/response_models/carpool_search_response_model.dart';
import 'package:green_cycle/models/response_models/contact_driver_response_model.dart';

void main() {
  Map<String, dynamic> resultWithSchedule(dynamic scheduleForDay) => {
        '_id': 'o1',
        'driver': {'_id': 'd', 'name': 'Sara', 'avatar': 'a', 'gender': 'female'},
        'destinationNameEn': 'x',
        'destinationNameAr': 'كلية',
        'checkpoints': [
          {'district': {'_id': 'c1', 'nameEn': 'Smouha', 'nameAr': 'سموحة'}, 'order': 0},
        ],
        'scheduleForDay': scheduleForDay,
        'weeklySchedule': [
          {'dayOfWeek': 'sunday', 'arrivalTime': '08:00', 'active': true},
        ],
        'notes': null,
      };

  test('scheduleForDay as an object is parsed', () {
    final model = SearchResponseModel.fromMap({
      'status': 'success',
      'results': 1,
      'data': {
        'offers': [
          resultWithSchedule({'dayOfWeek': 'sunday', 'arrivalTime': '08:00', 'active': true})
        ]
      }
    }, day: 'sunday');
    expect(model.offers.single.scheduleForDay?.arrivalTime, '08:00');
  });

  test('scheduleForDay as an array picks the matching day', () {
    final model = SearchResponseModel.fromMap({
      'data': {
        'offers': [
          resultWithSchedule([
            {'dayOfWeek': 'tuesday', 'arrivalTime': '09:00', 'active': true},
            {'dayOfWeek': 'sunday', 'arrivalTime': '08:15', 'active': true},
          ])
        ]
      }
    }, day: 'sunday');
    expect(model.offers.single.scheduleForDay?.arrivalTime, '08:15');
  });

  test('empty offers list parses to empty', () {
    expect(SearchResponseModel.fromMap({'data': {'offers': []}}).offers, isEmpty);
  });

  test('ContactDriverResponseModel parses driver + trip', () {
    final model = ContactDriverResponseModel.fromMap({
      'status': 'success',
      'data': {
        'driver': {'_id': 'd', 'name': 'Ahmed', 'phone': 1012345678, 'whatsappUrl': 'https://wa.me/201012345678'},
        'trip': {'_id': 't1', 'dayOfWeek': 'sunday', 'status': 'contacted'},
      }
    });
    expect(model.driver.whatsappUrl, 'https://wa.me/201012345678');
    expect(model.driver.phone, 1012345678);
    expect(model.trip.status, 'contacted');
  });

  test('ContactDriverRequest.toMap', () {
    expect(ContactDriverRequest(districtId: 'c1', dayOfWeek: 'sunday').toMap(),
        {'districtId': 'c1', 'dayOfWeek': 'sunday'});
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/carpool/search_contact_model_test.dart`
Expected: FAIL — models don't exist yet.

- [ ] **Step 3: Create the search response model**

Create `lib/models/response_models/carpool_search_response_model.dart`:

```dart
import 'package:green_cycle/models/response_models/carpool_offer_response_model.dart';

class CarpoolSearchResult {
  final String id;
  final CarpoolDriverSummary driver;
  final String destinationNameEn;
  final String destinationNameAr;
  final List<Checkpoint> checkpoints;
  final WeeklyScheduleEntry? scheduleForDay;
  final List<WeeklyScheduleEntry> weeklySchedule;
  final String? notes;

  CarpoolSearchResult({
    required this.id,
    required this.driver,
    required this.destinationNameEn,
    required this.destinationNameAr,
    required this.checkpoints,
    required this.scheduleForDay,
    required this.weeklySchedule,
    this.notes,
  });

  factory CarpoolSearchResult.fromMap(Map<String, dynamic> map, {String? day}) {
    return CarpoolSearchResult(
      id: map['_id'] ?? '',
      driver: CarpoolDriverSummary.fromMap(
          (map['driver'] as Map<String, dynamic>?) ?? const {}),
      destinationNameEn: map['destinationNameEn'] ?? '',
      destinationNameAr: map['destinationNameAr'] ?? '',
      checkpoints: parseCheckpoints(map['checkpoints'] as List?),
      scheduleForDay: _parseScheduleForDay(map['scheduleForDay'], day),
      weeklySchedule: ((map['weeklySchedule'] as List?) ?? const [])
          .map((e) => WeeklyScheduleEntry.fromMap(e as Map<String, dynamic>))
          .toList(),
      notes: map['notes'],
    );
  }

  /// The backend may return `scheduleForDay` as a single object or an array.
  static WeeklyScheduleEntry? _parseScheduleForDay(dynamic raw, String? day) {
    if (raw is Map) {
      return WeeklyScheduleEntry.fromMap(raw.cast<String, dynamic>());
    }
    if (raw is List && raw.isNotEmpty) {
      final match = raw.cast<Map>().firstWhere(
            (e) => day != null && e['dayOfWeek'] == day,
            orElse: () => raw.first as Map,
          );
      return WeeklyScheduleEntry.fromMap(match.cast<String, dynamic>());
    }
    return null;
  }
}

class SearchResponseModel {
  final List<CarpoolSearchResult> offers;

  SearchResponseModel({required this.offers});

  factory SearchResponseModel.fromMap(Map<String, dynamic> map, {String? day}) {
    final list = (map['data']?['offers'] as List?) ?? const [];
    return SearchResponseModel(
      offers: list
          .map((e) => CarpoolSearchResult.fromMap(e as Map<String, dynamic>, day: day))
          .toList(),
    );
  }
}
```

- [ ] **Step 4: Create the contact response + request models**

Create `lib/models/response_models/contact_driver_response_model.dart`:

```dart
class ContactDriver {
  final String id;
  final String name;
  final int? phone;
  final String whatsappUrl;

  ContactDriver({
    required this.id,
    required this.name,
    required this.phone,
    required this.whatsappUrl,
  });

  factory ContactDriver.fromMap(Map<String, dynamic> map) => ContactDriver(
        id: map['_id'] ?? '',
        name: map['name'] ?? '',
        phone: map['phone'],
        whatsappUrl: map['whatsappUrl'] ?? '',
      );
}

class CarpoolTrip {
  final String id;
  final String dayOfWeek;
  final String status;

  CarpoolTrip({required this.id, required this.dayOfWeek, required this.status});

  factory CarpoolTrip.fromMap(Map<String, dynamic> map) => CarpoolTrip(
        id: map['_id'] ?? '',
        dayOfWeek: map['dayOfWeek'] ?? '',
        status: map['status'] ?? '',
      );
}

class ContactDriverResponseModel {
  final ContactDriver driver;
  final CarpoolTrip trip;

  ContactDriverResponseModel({required this.driver, required this.trip});

  factory ContactDriverResponseModel.fromMap(Map<String, dynamic> map) {
    final data = (map['data'] as Map<String, dynamic>?) ?? const {};
    return ContactDriverResponseModel(
      driver: ContactDriver.fromMap((data['driver'] as Map<String, dynamic>?) ?? const {}),
      trip: CarpoolTrip.fromMap((data['trip'] as Map<String, dynamic>?) ?? const {}),
    );
  }
}
```

Create `lib/models/request_models/contact_driver_request_model.dart`:

```dart
class ContactDriverRequest {
  final String districtId;
  final String dayOfWeek;

  ContactDriverRequest({required this.districtId, required this.dayOfWeek});

  Map<String, dynamic> toMap() =>
      {'districtId': districtId, 'dayOfWeek': dayOfWeek};
}
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/carpool/search_contact_model_test.dart`
Expected: PASS (5 tests).

- [ ] **Step 6: Commit** (request approval first)

```bash
git add lib/models/response_models/carpool_search_response_model.dart lib/models/response_models/contact_driver_response_model.dart lib/models/request_models/contact_driver_request_model.dart test/carpool/search_contact_model_test.dart
git commit -m "feat(carpool): add search and contact models"
```

---

## Task 4: Carpool repository + bindings

**Files:**
- Create: `lib/modules/carpool/carpool_repo.dart`
- Create: `lib/modules/carpool/carpool_bindings.dart`

No unit test (network layer; verified when screens run). Verify it compiles.

- [ ] **Step 1: Create the repo**

Create `lib/modules/carpool/carpool_repo.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:green_cycle/models/request_models/contact_driver_request_model.dart';
import 'package:green_cycle/models/request_models/setup_offer_request_model.dart';
import 'package:green_cycle/models/response_models/carpool_offer_response_model.dart';
import 'package:green_cycle/models/response_models/carpool_search_response_model.dart';
import 'package:green_cycle/models/response_models/contact_driver_response_model.dart';
import 'package:green_cycle/models/response_models/district_response_model.dart';
import 'package:green_cycle/utilities/global/app_endpoints.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class CarpoolRepo {
  List<District>? _districtsCache;

  Future<List<District>> getDistricts({bool forceRefresh = false}) async {
    if (!forceRefresh && _districtsCache != null) return _districtsCache!;
    try {
      final res = await DioClient.publicDio.get(AppEndpoints.carpoolDistricts);
      _districtsCache = DistrictsResponseModel.fromMap(res.data).districts;
      return _districtsCache!;
    } on DioException catch (e) {
      throw MyCustomException(_message(e));
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  Future<CarpoolOffer?> getMyOffer() async {
    try {
      final res = await DioClient.privateDio.get(AppEndpoints.carpoolOfferMe);
      return OfferResponseModel.fromMap(res.data).offer;
    } on DioException catch (e) {
      throw MyCustomException(_message(e));
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  Future<CarpoolOffer?> upsertOffer(SetupOfferRequest request) async {
    try {
      final res = await DioClient.privateDio
          .post(AppEndpoints.carpoolOfferMe, data: request.toMap());
      return OfferResponseModel.fromMap(res.data).offer;
    } on DioException catch (e) {
      throw MyCustomException(_message(e));
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  /// Deactivates the current user's offer. A 404 ("no offer") is treated as
  /// success — the end state (no active offer) is the same.
  Future<void> deactivateOffer() async {
    try {
      await DioClient.privateDio.delete(AppEndpoints.carpoolOfferMe);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return;
      throw MyCustomException(_message(e));
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  /// Searches drivers. A 404 ("no matching offer") returns an empty list so the
  /// caller can show an empty state instead of an error.
  Future<List<CarpoolSearchResult>> search({
    required String districtId,
    String? dayOfWeek,
  }) async {
    try {
      final res = await DioClient.privateDio.get(
        AppEndpoints.carpoolSearch,
        queryParameters: {
          'districtId': districtId,
          if (dayOfWeek != null) 'dayOfWeek': dayOfWeek,
        },
      );
      return SearchResponseModel.fromMap(res.data, day: dayOfWeek).offers;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw MyCustomException(_message(e));
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  Future<ContactDriverResponseModel> contact({
    required String offerId,
    required String districtId,
    required String dayOfWeek,
  }) async {
    try {
      final res = await DioClient.privateDio.post(
        AppEndpoints.carpoolContact(offerId),
        data: ContactDriverRequest(districtId: districtId, dayOfWeek: dayOfWeek)
            .toMap(),
      );
      return ContactDriverResponseModel.fromMap(res.data);
    } on DioException catch (e) {
      throw MyCustomException(_message(e));
    } catch (e) {
      throw MyCustomException(e.toString());
    }
  }

  /// Extracts a message safely — the body may be a Map (JSON) or a String (HTML).
  String _message(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) return data['message'].toString();
    return e.message ?? 'حدث خطأ برجاء المحاولة لاحقاً';
  }
}
```

- [ ] **Step 2: Create the bindings**

Create `lib/modules/carpool/carpool_bindings.dart`:

```dart
import 'package:get/get.dart';
import 'package:green_cycle/modules/carpool/carpool_controller.dart';
import 'package:green_cycle/modules/carpool/carpool_repo.dart';

class CarpoolBindings extends Bindings {
  @override
  void dependencies() {
    // fenix: true so the repo (with its district cache) and shared controller
    // survive navigation across the carpool sub-screens.
    Get.lazyPut(() => CarpoolRepo(), fenix: true);
    Get.lazyPut(() => CarpoolController(), fenix: true);
  }
}
```

> Note: `CarpoolController` is created in Task 5. This file will not compile until then — commit Tasks 4 and 5 together, or create the controller first. Proceed to Task 5 before running analyze.

- [ ] **Step 3: Commit** (with Task 5)

Deferred — see Task 5 Step 8.

---

## Task 5: Routes, shared controller, Carpool Home, and Home entry card

**Files:**
- Create: `lib/modules/carpool/carpool_controller.dart`
- Create: `lib/modules/carpool/carpool_home_screen.dart`
- Modify: `lib/utilities/navigation/app_routes.dart`
- Modify: `lib/utilities/navigation/app_pages.dart`
- Modify: `lib/modules/tabs/home/home_tab.dart`

- [ ] **Step 1: Create the shared controller**

Create `lib/modules/carpool/carpool_controller.dart`:

```dart
import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/carpool_offer_response_model.dart';
import 'package:green_cycle/models/response_models/district_response_model.dart';
import 'package:green_cycle/modules/carpool/carpool_repo.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class CarpoolController extends BaseController {
  final _repo = Get.find<CarpoolRepo>();

  final RxList<District> districts = <District>[].obs;
  final Rxn<CarpoolOffer> myOffer = Rxn();

  bool get hasActiveOffer => myOffer.value?.isActive == true;

  @override
  void onInit() {
    if (isInit) {
      load();
      isInit = false;
    }
    super.onInit();
  }

  Future<void> load() async {
    try {
      setLoading = true;
      final results = await Future.wait([
        _repo.getDistricts(),
        _repo.getMyOffer(),
      ]);
      districts.assignAll(results[0] as List<District>);
      myOffer.value = results[1] as CarpoolOffer?;
      setError = false;
      update();
    } catch (e) {
      setError = true;
      showErrorDialog(e is MyCustomException ? e.message : AppConstants.error);
    } finally {
      setLoading = false;
    }
  }

  /// Re-fetch just the offer after setup/edit/deactivate.
  Future<void> refreshOffer() async {
    try {
      myOffer.value = await _repo.getMyOffer();
      update();
    } catch (_) {}
  }
}
```

- [ ] **Step 2: Add routes**

In `lib/utilities/navigation/app_routes.dart`, add before the closing brace:

```dart
  static const String carpoolHomeScreen = "/carpool-home-screen";
  static const String carpoolDriverSetupScreen = "/carpool-driver-setup-screen";
  static const String carpoolMyOfferScreen = "/carpool-my-offer-screen";
  static const String carpoolSearchScreen = "/carpool-search-screen";
```

- [ ] **Step 3: Register pages**

In `lib/utilities/navigation/app_pages.dart`, add these imports at the top:

```dart
import 'package:green_cycle/modules/carpool/carpool_bindings.dart';
import 'package:green_cycle/modules/carpool/carpool_home_screen.dart';
import 'package:green_cycle/modules/carpool/driver/driver_setup_screen.dart';
import 'package:green_cycle/modules/carpool/driver/my_offer_screen.dart';
import 'package:green_cycle/modules/carpool/passenger/passenger_search_screen.dart';
```

And add these `GetPage`s inside the `routes` list:

```dart
    GetPage(
      name: AppRoutes.carpoolHomeScreen,
      page: () => const CarpoolHomeScreen(),
      binding: CarpoolBindings(),
    ),
    GetPage(
      name: AppRoutes.carpoolDriverSetupScreen,
      page: () => const DriverSetupScreen(),
      binding: CarpoolBindings(),
    ),
    GetPage(
      name: AppRoutes.carpoolMyOfferScreen,
      page: () => const MyOfferScreen(),
      binding: CarpoolBindings(),
    ),
    GetPage(
      name: AppRoutes.carpoolSearchScreen,
      page: () => const PassengerSearchScreen(),
      binding: CarpoolBindings(),
    ),
```

> The screens `DriverSetupScreen`, `MyOfferScreen`, `PassengerSearchScreen` are created in Tasks 7–9. To keep the app compiling after this task, create **temporary stubs** for the three not-yet-built screens (each a `Scaffold` with a `Center(child: Text('...'))`) and replace them in their tasks. Stub example for `lib/modules/carpool/driver/driver_setup_screen.dart`:
> ```dart
> import 'package:flutter/material.dart';
> class DriverSetupScreen extends StatelessWidget {
>   const DriverSetupScreen({super.key});
>   @override
>   Widget build(BuildContext context) =>
>       const Scaffold(body: Center(child: Text('Driver setup — coming next')));
> }
> ```
> Create equivalent stubs for `passenger/passenger_search_screen.dart` (`PassengerSearchScreen`) and `driver/my_offer_screen.dart` (`MyOfferScreen`).

- [ ] **Step 4: Build the Carpool Home screen**

Create `lib/modules/carpool/carpool_home_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/carpool/carpool_controller.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/shared_widgets/custom_error_widget.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';

class CarpoolHomeScreen extends GetView<CarpoolController> {
  const CarpoolHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnHomeAppBar('مشاركة السيارة'),
      body: GetBuilder<CarpoolController>(
        init: controller,
        builder: (_) {
          if (controller.isLoading) return const CustomProgressIndicator();
          if (controller.isError) {
            return CustomErrorWidget(onRefresh: controller.load);
          }
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
              vertical: AppConstants.topPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _statusBadge(),
                SizedBox(height: 24.h),
                _actionCard(
                  title: 'أنا سائق',
                  subtitle: controller.hasActiveOffer
                      ? 'إدارة رحلتك الحالية'
                      : 'أنشئ رحلتك وشارك مقاعدك',
                  icon: Icons.directions_car,
                  onTap: () => Get.toNamed(
                    controller.hasActiveOffer
                        ? AppRoutes.carpoolMyOfferScreen
                        : AppRoutes.carpoolDriverSetupScreen,
                  ),
                ),
                SizedBox(height: 16.h),
                _actionCard(
                  title: 'أبحث عن مشوار',
                  subtitle: 'ابحث عن سائق يمر بمنطقتك',
                  icon: Icons.search,
                  onTap: () => Get.toNamed(AppRoutes.carpoolSearchScreen),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusBadge() {
    final active = controller.hasActiveOffer;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: active ? AppColors.kLightSecondary : AppColors.greyVeryLighF5,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        children: [
          Icon(active ? Icons.check_circle : Icons.info_outline,
              color: AppColors.primary, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              active ? 'عرضك نشط' : 'لا يوجد عرض بعد',
              style: Get.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      child: Container(
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26.sp,
              backgroundColor: AppColors.primary,
              child: Icon(icon, color: AppColors.white, size: 26.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Get.textTheme.headlineSmall),
                  SizedBox(height: 4.h),
                  Text(subtitle,
                      style: TextStyle(fontSize: 12.sp, color: AppColors.primary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Add the Home entry card**

In `lib/modules/tabs/home/home_tab.dart`, add imports:

```dart
import 'package:get/get.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';
```

(Some may already be imported — do not duplicate.) Then insert a carpool card between `GreenPointsSection` and the `Expanded` activities card. Replace:

```dart
          const GreenPointsSection(),
          SizedBox(height: 15.h),
          Expanded(
```

with:

```dart
          const GreenPointsSection(),
          SizedBox(height: 15.h),
          InkWell(
            onTap: () => Get.toNamed(AppRoutes.carpoolHomeScreen),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Row(
                children: [
                  Icon(Icons.directions_car, color: AppColors.white, size: 24.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'مشاركة السيارة',
                      style: Get.textTheme.headlineSmall!
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                  Icon(Icons.arrow_back_ios, color: AppColors.white, size: 16.sp),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Expanded(
```

- [ ] **Step 6: Analyze**

Run: `flutter analyze lib/modules/carpool lib/modules/tabs/home lib/utilities/navigation`
Expected: no errors (infos/warnings ok).

- [ ] **Step 7: Run the app and verify**

Launch the app (logged in). On Home, tap **مشاركة السيارة** → Carpool Home opens, shows the status badge ("عرضك نشط" or "لا يوجد عرض بعد") and two action cards. Tapping each navigates to the stub screens. Confirm districts/offer loaded (no error dialog).

- [ ] **Step 8: Commit** (request approval first — includes Task 4 files)

```bash
git add lib/modules/carpool/ lib/utilities/navigation/app_routes.dart lib/utilities/navigation/app_pages.dart lib/modules/tabs/home/home_tab.dart
git commit -m "feat(carpool): add repo, bindings, home screen, routing, and home entry card"
```

---

## Task 6: Shared widgets — route chain and district picker

**Files:**
- Create: `lib/modules/carpool/widgets/route_chain.dart`
- Create: `lib/modules/carpool/widgets/district_picker_sheet.dart`

No unit test (pure UI). Verify via analyze; exercised in Tasks 7–9.

- [ ] **Step 1: Create the route chain widget**

Create `lib/modules/carpool/widgets/route_chain.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/modules/carpool/carpool_utils.dart';
import 'package:green_cycle/theme/app_colors.dart';

/// Renders district names as a route: سيدي بشر ← سموحة ← الكلية.
/// [highlightId] (optional) bolds the passenger's district.
class RouteChain extends StatelessWidget {
  final List<({String id, String name})> stops;
  final String? highlightId;

  const RouteChain({super.key, required this.stops, this.highlightId});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (var i = 0; i < stops.length; i++) {
      final stop = stops[i];
      final highlighted = stop.id == highlightId;
      items.add(Text(
        stop.name,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.primary,
          fontWeight: highlighted ? FontWeight.w700 : FontWeight.w400,
          decoration: highlighted ? TextDecoration.underline : null,
        ),
      ));
      if (i != stops.length - 1) {
        items.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Icon(Icons.arrow_back, size: 14.sp, color: AppColors.grey85),
        ));
      }
    }
    // Append the destination (faculty) as the final stop.
    items.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Icon(Icons.arrow_back, size: 14.sp, color: AppColors.grey85),
    ));
    items.add(Text(
      'الكلية',
      style: TextStyle(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w600),
    ));

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 4.h,
      children: items,
    );
  }
}
```

- [ ] **Step 2: Create the district picker sheet**

Create `lib/modules/carpool/widgets/district_picker_sheet.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/district_response_model.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

/// Bottom sheet for picking a single district. Returns the chosen [District]
/// or null if dismissed. [excludeIds] hides already-selected districts.
Future<District?> showDistrictPicker(
  List<District> districts, {
  Set<String> excludeIds = const {},
}) {
  return Get.bottomSheet<District>(
    _DistrictPickerSheet(districts: districts, excludeIds: excludeIds),
    isScrollControlled: true,
    backgroundColor: AppColors.white,
  );
}

class _DistrictPickerSheet extends StatefulWidget {
  final List<District> districts;
  final Set<String> excludeIds;

  const _DistrictPickerSheet({required this.districts, required this.excludeIds});

  @override
  State<_DistrictPickerSheet> createState() => _DistrictPickerSheetState();
}

class _DistrictPickerSheetState extends State<_DistrictPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final available = widget.districts
        .where((d) => !widget.excludeIds.contains(d.id))
        .where((d) =>
            _query.isEmpty ||
            d.nameAr.contains(_query) ||
            d.nameEn.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.75.sh),
        padding: EdgeInsets.all(16.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'ابحث عن منطقة',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Flexible(
              child: available.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(24.sp),
                      child: const Text('لا توجد نتائج'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: available.length,
                      itemBuilder: (_, i) => ListTile(
                        title: Text(available[i].nameAr),
                        onTap: () => Get.back(result: available[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Analyze**

Run: `flutter analyze lib/modules/carpool/widgets`
Expected: no errors.

- [ ] **Step 4: Commit** (request approval first)

```bash
git add lib/modules/carpool/widgets/route_chain.dart lib/modules/carpool/widgets/district_picker_sheet.dart
git commit -m "feat(carpool): add route chain and district picker widgets"
```

---

## Task 7: Passenger search

**Files:**
- Create: `lib/modules/carpool/passenger/passenger_search_controller.dart`
- Create: `lib/modules/carpool/widgets/driver_result_card.dart`
- Replace stub: `lib/modules/carpool/passenger/passenger_search_screen.dart`

- [ ] **Step 1: Create the search controller**

Create `lib/modules/carpool/passenger/passenger_search_controller.dart`:

```dart
import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/carpool_search_response_model.dart';
import 'package:green_cycle/models/response_models/district_response_model.dart';
import 'package:green_cycle/modules/carpool/carpool_controller.dart';
import 'package:green_cycle/modules/carpool/carpool_repo.dart';
import 'package:green_cycle/modules/carpool/carpool_utils.dart';
import 'package:green_cycle/modules/carpool/whatsapp_launcher.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class PassengerSearchController extends BaseController {
  final _repo = Get.find<CarpoolRepo>();

  final RxList<District> districts = <District>[].obs;
  final Rxn<District> selectedDistrict = Rxn();
  final RxString selectedDay = CarpoolDays.all.first.obs;

  final RxList<CarpoolSearchResult> results = <CarpoolSearchResult>[].obs;
  final RxBool hasSearched = false.obs;
  final RxBool searching = false.obs;

  @override
  void onInit() {
    districts.assignAll(Get.find<CarpoolController>().districts);
    super.onInit();
  }

  void selectDistrict(District d) {
    selectedDistrict.value = d;
    update();
  }

  void selectDay(String day) {
    selectedDay.value = day;
    update();
  }

  Future<void> runSearch() async {
    if (selectedDistrict.value == null) return;
    try {
      searching.value = true;
      update();
      final r = await _repo.search(
        districtId: selectedDistrict.value!.id,
        dayOfWeek: selectedDay.value,
      );
      results.assignAll(r);
      hasSearched.value = true;
    } catch (e) {
      showErrorDialog(e is MyCustomException ? e.message : AppConstants.error);
    } finally {
      searching.value = false;
      update();
    }
  }

  Future<void> contactDriver(CarpoolSearchResult offer) async {
    try {
      showLoadingOverlay();
      final res = await _repo.contact(
        offerId: offer.id,
        districtId: selectedDistrict.value!.id,
        dayOfWeek: selectedDay.value,
      );
      hideLoadingOverlay();
      final opened = await WhatsappLauncher.open(
        res.driver.whatsappUrl,
        message: _prefilledMessage(),
      );
      if (!opened) {
        Get.snackbar('واتساب', 'تعذّر فتح واتساب على هذا الجهاز',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      hideLoadingOverlay();
      // Most likely 404: the driver deactivated the offer since the search.
      Get.snackbar('غير متاح', 'لم يعد هذا العرض متاحاً، جرّب عرضاً آخر',
          snackPosition: SnackPosition.BOTTOM);
      runSearch();
    }
  }

  String _prefilledMessage() =>
      'مرحباً، وجدت عرضك على Green Cycle وأحتاج مشاركة سيارة يوم ${CarpoolDays.label(selectedDay.value)}';
}
```

- [ ] **Step 2: Create the driver result card**

Create `lib/modules/carpool/widgets/driver_result_card.dart`:

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/response_models/carpool_search_response_model.dart';
import 'package:green_cycle/modules/carpool/widgets/route_chain.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class DriverResultCard extends StatelessWidget {
  final CarpoolSearchResult offer;
  final String passengerDistrictId;
  final VoidCallback onContact;

  const DriverResultCard({
    super.key,
    required this.offer,
    required this.passengerDistrictId,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final arrival = offer.scheduleForDay?.arrivalTime;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.greyD5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22.sp,
                backgroundColor: AppColors.secondary,
                backgroundImage: offer.driver.avatar.isEmpty
                    ? null
                    : CachedNetworkImageProvider(offer.driver.avatar),
                child: offer.driver.avatar.isEmpty
                    ? const Icon(Icons.person, color: AppColors.primary)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(offer.driver.name, style: Get.textTheme.headlineSmall),
              ),
              if (arrival != null)
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14.sp, color: AppColors.primary),
                    SizedBox(width: 4.w),
                    Text(arrival, style: TextStyle(fontSize: 12.sp)),
                  ],
                ),
            ],
          ),
          SizedBox(height: 12.h),
          RouteChain(
            stops: offer.checkpoints
                .map((c) => (id: c.district.id, name: c.district.nameAr))
                .toList(),
            highlightId: passengerDistrictId,
          ),
          if (offer.notes != null && offer.notes!.trim().isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(offer.notes!, style: TextStyle(fontSize: 12.sp, color: AppColors.grey5B)),
          ],
          SizedBox(height: 14.h),
          PrimaryButton(
            text: 'تواصل عبر واتساب',
            onTap: onContact,
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Build the search screen (replace the stub)**

Replace `lib/modules/carpool/passenger/passenger_search_screen.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/carpool/carpool_controller.dart';
import 'package:green_cycle/modules/carpool/carpool_utils.dart';
import 'package:green_cycle/modules/carpool/passenger/passenger_search_controller.dart';
import 'package:green_cycle/modules/carpool/widgets/district_picker_sheet.dart';
import 'package:green_cycle/modules/carpool/widgets/driver_result_card.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/shared_widgets/custom_progress_indicator.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class PassengerSearchScreen extends StatelessWidget {
  const PassengerSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The shared CarpoolController is already registered by CarpoolBindings.
    Get.find<CarpoolController>();
    final controller = Get.put(PassengerSearchController());

    return Scaffold(
      appBar: returnHomeAppBar('أبحث عن مشوار'),
      body: GetBuilder<PassengerSearchController>(
        init: controller,
        builder: (_) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
            vertical: AppConstants.topPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _districtField(controller),
              SizedBox(height: 12.h),
              _dayPicker(controller),
              SizedBox(height: 16.h),
              PrimaryButton(
                text: 'بحث',
                isLoading: controller.searching.value,
                onTap: controller.selectedDistrict.value == null
                    ? null
                    : controller.runSearch,
              ),
              SizedBox(height: 16.h),
              Expanded(child: _results(controller)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _districtField(PassengerSearchController controller) {
    final selected = controller.selectedDistrict.value;
    return InkWell(
      onTap: () async {
        final picked = await showDistrictPicker(controller.districts);
        if (picked != null) controller.selectDistrict(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'منطقتك',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        child: Text(selected?.nameAr ?? 'اختر المنطقة'),
      ),
    );
  }

  Widget _dayPicker(PassengerSearchController controller) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: CarpoolDays.all.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final day = CarpoolDays.all[i];
          final selected = controller.selectedDay.value == day;
          return ChoiceChip(
            label: Text(CarpoolDays.label(day)),
            selected: selected,
            selectedColor: AppColors.secondary,
            onSelected: (_) => controller.selectDay(day),
          );
        },
      ),
    );
  }

  Widget _results(PassengerSearchController controller) {
    if (controller.searching.value) return const CustomProgressIndicator();
    if (!controller.hasSearched.value) {
      return const SizedBox();
    }
    if (controller.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_outlined, size: 48.sp, color: AppColors.greyA3),
            SizedBox(height: 12.h),
            const Text('لا يوجد سائقون متاحون لهذه المنطقة واليوم'),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: controller.results.length,
      itemBuilder: (_, i) {
        final offer = controller.results[i];
        return DriverResultCard(
          offer: offer,
          passengerDistrictId: controller.selectedDistrict.value!.id,
          onContact: () => controller.contactDriver(offer),
        );
      },
    );
  }
}
```

- [ ] **Step 4: Analyze**

Run: `flutter analyze lib/modules/carpool/passenger lib/modules/carpool/widgets`
Expected: no errors.

- [ ] **Step 5: Run the app and verify**

Carpool → **أبحث عن مشوار**. Pick a district + day → **بحث**. Verify: matching drivers appear as cards (name, arrival time, route with your district highlighted, notes); empty state shows when none; **تواصل عبر واتساب** opens WhatsApp with a pre-filled Arabic message. (Set up a driver offer first — Task 8 — if there are no results.)

- [ ] **Step 6: Commit** (request approval first)

```bash
git add lib/modules/carpool/passenger/ lib/modules/carpool/widgets/driver_result_card.dart
git commit -m "feat(carpool): add passenger search and WhatsApp contact"
```

---

## Task 8: Driver setup wizard

**Files:**
- Create: `lib/modules/carpool/driver/driver_setup_controller.dart`
- Create: `lib/modules/carpool/widgets/day_schedule_row.dart`
- Replace stub: `lib/modules/carpool/driver/driver_setup_screen.dart`

- [ ] **Step 1: Create the setup controller**

Create `lib/modules/carpool/driver/driver_setup_controller.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cycle/models/request_models/setup_offer_request_model.dart';
import 'package:green_cycle/models/response_models/carpool_offer_response_model.dart';
import 'package:green_cycle/models/response_models/district_response_model.dart';
import 'package:green_cycle/modules/carpool/carpool_controller.dart';
import 'package:green_cycle/modules/carpool/carpool_repo.dart';
import 'package:green_cycle/modules/carpool/carpool_utils.dart';
import 'package:green_cycle/utilities/base/base_controller.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';

class DriverSetupController extends BaseController {
  final _repo = Get.find<CarpoolRepo>();
  final _carpool = Get.find<CarpoolController>();

  final RxInt step = 0.obs;

  /// day -> "HH:MM"; presence means the day is enabled.
  final RxMap<String, String> schedule = <String, String>{}.obs;
  final RxList<District> selectedCheckpoints = <District>[].obs;
  final TextEditingController notesController = TextEditingController();

  List<District> get allDistricts => _carpool.districts;

  bool get isEditing => _carpool.hasActiveOffer;

  @override
  void onInit() {
    if (isEditing) _prefillFrom(_carpool.myOffer.value!);
    super.onInit();
  }

  void _prefillFrom(CarpoolOffer offer) {
    for (final s in offer.weeklySchedule) {
      schedule[s.dayOfWeek] = s.arrivalTime;
    }
    selectedCheckpoints.assignAll(offer.checkpoints.map((c) => c.district));
    notesController.text = offer.notes ?? '';
  }

  void toggleDay(String day, bool on) {
    if (on) {
      schedule[day] = schedule[day] ?? '08:00';
    } else {
      schedule.remove(day);
    }
    update();
  }

  void setDayTime(String day, TimeOfDay time) {
    schedule[day] = formatTimeOfDay(time);
    update();
  }

  void addCheckpoint(District d) {
    if (!selectedCheckpoints.any((c) => c.id == d.id)) {
      selectedCheckpoints.add(d);
      update();
    }
  }

  void removeCheckpoint(String id) {
    selectedCheckpoints.removeWhere((c) => c.id == id);
    update();
  }

  void reorderCheckpoints(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = selectedCheckpoints.removeAt(oldIndex);
    selectedCheckpoints.insert(newIndex, item);
    update();
  }

  void next() {
    if (step.value == 0 && schedule.isEmpty) {
      showErrorDialog('اختر يوماً واحداً على الأقل');
      return;
    }
    if (step.value == 1 && selectedCheckpoints.isEmpty) {
      showErrorDialog('أضف منطقة واحدة على الأقل لخط سيرك');
      return;
    }
    if (step.value < 2) {
      step.value++;
      update();
    }
  }

  void back() {
    if (step.value > 0) {
      step.value--;
      update();
    }
  }

  Future<void> submit() async {
    if (schedule.isEmpty) {
      showErrorDialog('اختر يوماً واحداً على الأقل');
      return;
    }
    if (selectedCheckpoints.isEmpty) {
      showErrorDialog('أضف منطقة واحدة على الأقل لخط سيرك');
      return;
    }
    if (notesController.text.length > 500) {
      showErrorDialog('الملاحظات يجب ألا تتجاوز 500 حرف');
      return;
    }

    final request = SetupOfferRequest(
      weeklySchedule: schedule.entries
          .map((e) => WeeklyScheduleEntry(dayOfWeek: e.key, arrivalTime: e.value))
          .toList(),
      checkpoints: selectedCheckpoints
          .asMap()
          .entries
          .map((e) => CheckpointInput(district: e.value.id, order: e.key))
          .toList(),
      notes: notesController.text,
    );

    try {
      showLoadingOverlay();
      await _repo.upsertOffer(request);
      await _carpool.refreshOffer();
      hideLoadingOverlay();
      showSuccessDialog('تم نشر رحلتك', 'أصبح عرضك مرئياً للباحثين عن مشوار',
          onTap: () {
        Get.back(); // close dialog
        Get.back(); // back to carpool home
      });
    } catch (e) {
      hideLoadingOverlay();
      showErrorDialog(e is MyCustomException ? e.message : AppConstants.error);
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
```

- [ ] **Step 2: Create the day schedule row widget**

Create `lib/modules/carpool/widgets/day_schedule_row.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_cycle/theme/app_colors.dart';

class DayScheduleRow extends StatelessWidget {
  final String label;
  final bool enabled;
  final String? time; // "HH:MM" when enabled
  final ValueChanged<bool> onToggle;
  final VoidCallback onPickTime;

  const DayScheduleRow({
    super.key,
    required this.label,
    required this.enabled,
    required this.time,
    required this.onToggle,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Switch(
            value: enabled,
            activeColor: AppColors.primary,
            onChanged: onToggle,
          ),
          SizedBox(width: 8.w),
          Expanded(child: Text(label, style: TextStyle(fontSize: 14.sp))),
          if (enabled)
            TextButton.icon(
              onPressed: onPickTime,
              icon: Icon(Icons.access_time, size: 18.sp, color: AppColors.primary),
              label: Text(time ?? '08:00',
                  style: const TextStyle(color: AppColors.primary)),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Build the wizard screen (replace the stub)**

Replace `lib/modules/carpool/driver/driver_setup_screen.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/carpool/carpool_utils.dart';
import 'package:green_cycle/modules/carpool/driver/driver_setup_controller.dart';
import 'package:green_cycle/modules/carpool/widgets/day_schedule_row.dart';
import 'package:green_cycle/modules/carpool/widgets/district_picker_sheet.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';

class DriverSetupScreen extends StatelessWidget {
  const DriverSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverSetupController());
    return Scaffold(
      appBar: returnHomeAppBar(controller.isEditing ? 'تعديل رحلتي' : 'إعداد رحلتي'),
      body: GetBuilder<DriverSetupController>(
        init: controller,
        builder: (_) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
            vertical: AppConstants.topPadding,
          ),
          child: Column(
            children: [
              Expanded(child: _stepBody(context, controller)),
              _footer(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepBody(BuildContext context, DriverSetupController c) {
    switch (c.step.value) {
      case 0:
        return _scheduleStep(context, c);
      case 1:
        return _routeStep(c);
      default:
        return _notesStep(c);
    }
  }

  // Step 1 — weekly schedule
  Widget _scheduleStep(BuildContext context, DriverSetupController c) {
    return ListView(
      children: [
        Text('اختر أيام رحلتك ومواعيد الوصول', style: Get.textTheme.headlineSmall),
        SizedBox(height: 12.h),
        ...CarpoolDays.all.map((day) {
          final enabled = c.schedule.containsKey(day);
          return DayScheduleRow(
            label: CarpoolDays.label(day),
            enabled: enabled,
            time: c.schedule[day],
            onToggle: (on) => c.toggleDay(day, on),
            onPickTime: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: parseHHmm(c.schedule[day] ?? '08:00'),
              );
              if (picked != null) c.setDayTime(day, picked);
            },
          );
        }),
      ],
    );
  }

  // Step 2 — route checkpoints (drag to reorder)
  Widget _routeStep(DriverSetupController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('خط سيرك (اسحب لإعادة الترتيب)', style: Get.textTheme.headlineSmall),
        SizedBox(height: 8.h),
        OutlinedButton.icon(
          onPressed: () async {
            final picked = await showDistrictPicker(
              c.allDistricts,
              excludeIds: c.selectedCheckpoints.map((d) => d.id).toSet(),
            );
            if (picked != null) c.addCheckpoint(picked);
          },
          icon: const Icon(Icons.add, color: AppColors.primary),
          label: const Text('أضف منطقة'),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ReorderableListView(
            onReorder: c.reorderCheckpoints,
            children: [
              for (final d in c.selectedCheckpoints)
                ListTile(
                  key: ValueKey(d.id),
                  leading: const Icon(Icons.drag_handle, color: AppColors.grey85),
                  title: Text(d.nameAr),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.danger),
                    onPressed: () => c.removeCheckpoint(d.id),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              const Icon(Icons.school, color: AppColors.primary),
              SizedBox(width: 8.w),
              Expanded(child: Text('الوجهة: $kCarpoolDestinationAr')),
            ],
          ),
        ),
      ],
    );
  }

  // Step 3 — notes
  Widget _notesStep(DriverSetupController c) {
    return ListView(
      children: [
        Text('ملاحظات (اختياري)', style: Get.textTheme.headlineSmall),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          children: ['سيدات فقط', 'مقعدان متاحان'].map((chip) {
            return ActionChip(
              label: Text(chip),
              onPressed: () {
                final text = c.notesController.text;
                c.notesController.text = text.isEmpty ? chip : '$text، $chip';
              },
            );
          }).toList(),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: c.notesController,
          maxLength: 500,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'مثال: أنطلق من سيدي بشر، مقعدان متاحان',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
        ),
      ],
    );
  }

  Widget _footer(DriverSetupController c) {
    final isLast = c.step.value == 2;
    return Row(
      children: [
        if (c.step.value > 0)
          Expanded(
            child: PrimaryButton(
              text: 'رجوع',
              backgroundColor: AppColors.white,
              textColor: AppColors.primary,
              onTap: c.back,
            ),
          ),
        if (c.step.value > 0) SizedBox(width: 12.w),
        Expanded(
          child: PrimaryButton(
            text: isLast ? 'نشر الرحلة' : 'التالي',
            onTap: isLast ? c.submit : c.next,
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Analyze**

Run: `flutter analyze lib/modules/carpool/driver lib/modules/carpool/widgets/day_schedule_row.dart`
Expected: no errors.

- [ ] **Step 5: Run the app and verify**

Carpool → **أنا سائق** (with no existing offer) → wizard. Step 1: toggle days + pick times. Step 2: add districts, drag to reorder, remove one. Step 3: type notes / tap a chip. **نشر الرحلة** → success dialog → back on Carpool Home the badge shows **عرضك نشط**. Then search (Task 7) as another user/district to confirm the offer appears.

- [ ] **Step 6: Commit** (request approval first)

```bash
git add lib/modules/carpool/driver/driver_setup_controller.dart lib/modules/carpool/driver/driver_setup_screen.dart lib/modules/carpool/widgets/day_schedule_row.dart
git commit -m "feat(carpool): add driver setup wizard"
```

---

## Task 9: My Offer screen (view / edit / deactivate)

**Files:**
- Replace stub: `lib/modules/carpool/driver/my_offer_screen.dart`

- [ ] **Step 1: Build the My Offer screen**

Replace `lib/modules/carpool/driver/my_offer_screen.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:green_cycle/modules/carpool/carpool_controller.dart';
import 'package:green_cycle/modules/carpool/carpool_repo.dart';
import 'package:green_cycle/modules/carpool/carpool_utils.dart';
import 'package:green_cycle/modules/carpool/widgets/route_chain.dart';
import 'package:green_cycle/modules/home_layout/widgets/home_app_bar.dart';
import 'package:green_cycle/shared_widgets/primary_button.dart';
import 'package:green_cycle/theme/app_colors.dart';
import 'package:green_cycle/utilities/global/app_constants.dart';
import 'package:green_cycle/utilities/network/dio_client.dart';
import 'package:green_cycle/utilities/navigation/app_routes.dart';

class MyOfferScreen extends StatelessWidget {
  const MyOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CarpoolController>();
    return Scaffold(
      appBar: returnHomeAppBar('رحلتي'),
      body: GetBuilder<CarpoolController>(
        init: controller,
        builder: (_) {
          final offer = controller.myOffer.value;
          if (offer == null) {
            return const Center(child: Text('لا يوجد عرض نشط'));
          }
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
              vertical: AppConstants.topPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('المواعيد', style: Get.textTheme.headlineSmall),
                SizedBox(height: 8.h),
                ...offer.weeklySchedule.map((s) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(CarpoolDays.label(s.dayOfWeek)),
                          Text(s.arrivalTime),
                        ],
                      ),
                    )),
                SizedBox(height: 16.h),
                Text('خط السير', style: Get.textTheme.headlineSmall),
                SizedBox(height: 8.h),
                RouteChain(
                  stops: offer.checkpoints
                      .map((c) => (id: c.district.id, name: c.district.nameAr))
                      .toList(),
                ),
                if (offer.notes != null && offer.notes!.trim().isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Text('ملاحظات', style: Get.textTheme.headlineSmall),
                  SizedBox(height: 8.h),
                  Text(offer.notes!),
                ],
                const Spacer(),
                PrimaryButton(
                  text: 'تعديل',
                  onTap: () => Get.toNamed(AppRoutes.carpoolDriverSetupScreen),
                ),
                SizedBox(height: 12.h),
                PrimaryButton(
                  text: 'إيقاف العرض',
                  backgroundColor: AppColors.white,
                  textColor: AppColors.danger,
                  borderColor: AppColors.danger,
                  onTap: () => _confirmDeactivate(controller),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDeactivate(CarpoolController controller) {
    Get.defaultDialog(
      title: 'إيقاف العرض',
      middleText: 'هل تريد إيقاف عرضك؟ لن يظهر للباحثين بعد الآن.',
      textCancel: 'إلغاء',
      textConfirm: 'إيقاف',
      confirmTextColor: AppColors.white,
      buttonColor: AppColors.danger,
      onConfirm: () async {
        Get.back(); // close dialog
        try {
          controller.showLoadingOverlay();
          await Get.find<CarpoolRepo>().deactivateOffer();
          await controller.refreshOffer();
          controller.hideLoadingOverlay();
          Get.back(); // back to carpool home
          Get.snackbar('تم', 'تم إيقاف عرضك', snackPosition: SnackPosition.BOTTOM);
        } catch (e) {
          controller.hideLoadingOverlay();
          controller.showErrorDialog(
              e is MyCustomException ? e.message : AppConstants.error);
        }
      },
    );
  }
}
```

- [ ] **Step 2: Analyze**

Run: `flutter analyze lib/modules/carpool/driver/my_offer_screen.dart`
Expected: no errors.

- [ ] **Step 3: Run the app and verify**

Carpool → **أنا سائق** (with an existing offer) → My Offer shows schedule, route, notes. **تعديل** opens the wizard pre-filled; saving updates the offer. **إيقاف العرض** → confirm → offer deactivated, back on Home badge flips to **لا يوجد عرض**; a re-search no longer returns it.

- [ ] **Step 4: Commit** (request approval first)

```bash
git add lib/modules/carpool/driver/my_offer_screen.dart
git commit -m "feat(carpool): add my-offer view, edit, and deactivate"
```

---

## Task 10: Full verification pass

**Files:** none (verification + any small fixes).

- [ ] **Step 1: Run the whole test suite**

Run: `flutter test`
Expected: all carpool model/util tests + existing `auth_session` tests PASS.

- [ ] **Step 2: Analyze the whole project**

Run: `flutter analyze`
Expected: no new errors introduced by the carpool module.

- [ ] **Step 3: End-to-end manual checklist**

Verify against the spec's testing checklist:
- Driver: setup 1 day/1 checkpoint; multi-day + reordered route; edit via wizard; deactivate hides from search; notes >500 blocked; time picker outputs `HH:MM`.
- Passenger: search with district+day returns matches; own offer never appears; contact opens WhatsApp; contact on a deactivated offer → snackbar + refresh.
- Auth: with an expired/no token, protected calls redirect to login (from the earlier interceptor).
- RTL: route chain, pickers, and wizard render correctly in Arabic.

- [ ] **Step 4: Fix any issues found**, then re-run Steps 1–2.

- [ ] **Step 5: Commit** (request approval first, if fixes were made)

```bash
git add -A
git commit -m "test(carpool): verification pass and fixes"
```

---

## Self-Review

**Spec coverage:**
- Endpoints (§3) → Task 1. Auth split public/private → Task 4 repo. ✅
- Models incl. `scheduleForDay` object|array (§5) → Tasks 2, 3. ✅
- Module/file tree (§4) → Tasks 4–9. ✅
- Carpool Home + status badge + Home card (§6.1) → Task 5. ✅
- Driver wizard, drag-reorder, notes chips, validation (§6.2, §8) → Task 8. ✅
- My Offer view/edit/deactivate (§6.3) → Task 9. ✅
- Passenger search + highlight + WhatsApp + empty state (§6.4) → Tasks 6, 7. ✅
- State/caching/fenix (§7) → Tasks 4, 5. ✅
- Error handling: repo safe message, search/deactivate 404 as normal, 401 via interceptor (§9) → Task 4 repo + controllers. ✅
- Out of scope (§10) → nothing built for those. ✅
- Task 0 covers the §2 cookie-JWT assumption. ✅

**Placeholder scan:** No TBD/TODO. Temporary screen stubs in Task 5 are explicitly created and explicitly replaced in Tasks 7–9 (not placeholders — they keep the app compiling between tasks).

**Type consistency:** `District`, `WeeklyScheduleEntry`, `Checkpoint`, `CheckpointInput`, `CarpoolDriverSummary`, `CarpoolOffer`, `OfferResponseModel`, `CarpoolSearchResult`, `SearchResponseModel`, `ContactDriver`, `CarpoolTrip`, `ContactDriverResponseModel`, `SetupOfferRequest`, `ContactDriverRequest`, `CarpoolRepo`, `CarpoolController`, `CarpoolBindings`, `PassengerSearchController`, `DriverSetupController` — each defined once and referenced consistently. `parseCheckpoints`, `formatTimeOfDay`, `parseHHmm`, `CarpoolDays.label`, `WhatsappLauncher.buildUri/open`, `showDistrictPicker`, `RouteChain`, `DayScheduleRow`, `DriverResultCard` — signatures match their call sites.
