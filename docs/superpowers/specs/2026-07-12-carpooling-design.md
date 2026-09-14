# Carpooling Feature — Design Spec

- **Date:** 2026-07-12
- **App:** green_cycle (Flutter, GetX + Dio, Arabic/RTL, Alexandria University Faculty of Pharmacy)
- **Status:** Approved design — ready for implementation planning

## 1. Overview

Add a carpooling feature so faculty members can share rides to campus and cut CO₂.
Two roles:

- **Driver** — posts one carpool offer: a weekly schedule (which days + arrival time) and a
  route of districts they pass through (**checkpoints**). Contactable by passengers.
- **Passenger** — picks their home district + a day, searches for drivers whose route includes
  that district, then contacts the driver **on WhatsApp**.

This is the **WhatsApp-handoff** model that the backend actually shipped. It intentionally differs
from the older June plan (in-app seat approval + green points + enforced women-only). Those are
**not** part of this build (see §10). "Women only" is expressible only as free text in the driver's
notes.

Key backend behaviours we rely on:

- Each user has **at most one** active offer (upsert on `POST/PATCH /offers/me`).
- Search **never returns the current user's own offer**.
- The driver's phone is revealed **only** by the contact endpoint (which also logs a trip).
- Default destination: **كلية الصيدلة - جامعة الإسكندرية**.

## 2. Decisions (settled)

| Topic | Decision |
|-------|----------|
| Backend | Reuse the app's existing backend `AppEndpoints.baseUrl` (onrender). The carpool routes are already live there. The guide's `98.92.252.75` is stale/404 — ignore it. |
| Auth | `publicDio` for districts/days; `privateDio` (existing `Cookie: JWT=` auth) for offers/search/contact. |
| Scope | Full flow — both driver and passenger sides. |
| Placement | A **card on the Home tab** opens a dedicated full-screen Carpool section. The 5-tab bottom bar is unchanged (no 6th tab). |
| Language | **Arabic-only** (app is `supportedLocales: [Locale('ar')]`). Use `nameAr`, Arabic day labels, Arabic destination. |
| Route ordering | Driver **drags to reorder** checkpoints (`ReorderableListView`). |
| Contact flow | **Direct to WhatsApp** — no confirmation dialog. Open `whatsappUrl` with a pre-filled Arabic message. |

### Assumption to verify first (implementation step 1)

The protected carpool routes are assumed to accept the same **cookie JWT** the app already uses for
`users/me` and `leaderboard/me` on this backend. Verify with a real login token against
`GET /carpool/offers/me` before building the UI. If they require `Authorization: Bearer`, it's a
one-line header addition on `privateDio` for these calls.

## 3. Backend integration

Base URL: `https://green-cycle-juiq.onrender.com/api/v1/` (existing `AppEndpoints.baseUrl`).

Add to `lib/utilities/global/app_endpoints.dart`:

```dart
static const carpoolDistricts = '${baseUrl}carpool/districts';
static const carpoolDays       = '${baseUrl}carpool/days';
static const carpoolOfferMe    = '${baseUrl}carpool/offers/me';
static const carpoolSearch     = '${baseUrl}carpool/offers/search';
static String carpoolContact(String offerId) =>
    '${baseUrl}carpool/offers/$offerId/contact';
```

| Method | Endpoint | Dio | Purpose |
|--------|----------|-----|---------|
| GET | `carpool/districts` | public | List Alexandria districts (61 seeded) |
| GET | `carpool/days` | public | Valid days of week (can also hardcode) |
| GET | `carpool/offers/me` | private | My active offer (or `offer: null`) |
| POST/PATCH | `carpool/offers/me` | private | Create/update my offer (upsert) |
| DELETE | `carpool/offers/me` | private | Deactivate my offer (`isActive:false`) |
| GET | `carpool/offers/search?districtId=&dayOfWeek=` | private | Search drivers |
| POST | `carpool/offers/:offerId/contact` | private | Reveal phone + log trip |

Standard envelope: success `{status:"success", results?, data:{...}}`; failure `{status:"fail", message}`.

**Auth-expiry:** protected carpool calls automatically inherit the session-expiry handling added in
commit `2261e40` — a `privateDio` 401 interceptor that redirects to login. No per-call handling
needed (once the backend returns a clean 401).

## 4. Architecture / files

New module `lib/modules/carpool/`, mirroring the `tabs/streak_board` convention
(`_repo` / `_controller` / screen + `widgets/`), but reached by route (not a bottom-nav tab).

```
lib/modules/carpool/
  carpool_bindings.dart            # Get.lazyPut repo + shared CarpoolController (fenix)
  carpool_repo.dart                # ALL carpool endpoints + in-memory district cache
  carpool_controller.dart          # Home screen: my-offer status + districts
  carpool_home_screen.dart         # Entry: status badge + "سائق" / "راكب" cards
  driver/
    driver_setup_controller.dart   # Wizard state: schedule map, ordered checkpoints, notes
    driver_setup_screen.dart       # 3-step wizard
    my_offer_screen.dart           # View / Edit / Deactivate
  passenger/
    passenger_search_controller.dart
    passenger_search_screen.dart   # Filters + result cards + WhatsApp
  widgets/
    day_schedule_row.dart          # Day toggle + time picker
    route_chain.dart               # سيدي بشر ← سموحة ← الكلية (RTL arrows)
    driver_result_card.dart        # Search result card
    district_picker_sheet.dart     # Searchable district selector (client-side filter)

lib/models/response_models/
    district_response_model.dart       # District + DistrictsResponseModel
    carpool_offer_response_model.dart  # CarpoolOffer, WeeklyScheduleEntry, Checkpoint, DriverSummary
    carpool_search_response_model.dart # CarpoolSearchResult (+ scheduleForDay object|array)
    contact_driver_response_model.dart # driver contact + trip

lib/models/request_models/
    setup_offer_request_model.dart     # weeklySchedule, checkpoints, destination?, notes?
    contact_driver_request_model.dart  # districtId, dayOfWeek
```

Edits to existing files:

- `lib/utilities/global/app_endpoints.dart` — +5 endpoints (above).
- `lib/utilities/navigation/app_routes.dart` — +4 routes.
- `lib/utilities/navigation/app_pages.dart` — +4 `GetPage`s with bindings.
- `lib/modules/tabs/home/home_tab.dart` — insert a Carpool entry card.

## 5. Data models

All models use `fromMap` like the existing ones and read `_id` into `id`. Missing/null fields
default safely.

- **District** — `id, nameEn, nameAr`.
- **WeeklyScheduleEntry** — `dayOfWeek (String), arrivalTime (String "HH:MM"), active (bool, default true)`. `toMap` for requests.
- **Checkpoint** (response) — `district: District, order: int`.
- **CheckpointInput** (request) — `district: String (id), order: int` → `toMap`.
- **CarpoolDriverSummary** — `id, name, avatar, gender`. (`phone` optional; present on offer/contact, absent in search.)
- **CarpoolOffer** — `id, driver, destinationNameEn, destinationNameAr, weeklySchedule[], checkpoints[], isActive, notes?, createdAt, updatedAt`.
- **CarpoolSearchResult** — `id, driver, destinationNameEn/Ar, checkpoints[], scheduleForDay, weeklySchedule[], notes?`.
  - `scheduleForDay` may be an **object or an array** per the guide → parse defensively: if a `List`, take the entry whose `dayOfWeek` matches the searched day (else first); if a `Map`, use directly.
- **ContactDriverResponse** — `driver{ id, name, phone(int), whatsappUrl }, trip{ id, dayOfWeek, status }`.
- **SetupOfferRequest** — `weeklySchedule[], checkpoints[], destinationNameEn?, destinationNameAr?, notes?`. Destination omitted → backend applies the faculty default. Checkpoints sent as `{district, order}` (the `district` alias, not `districtId`).
- **ContactDriverRequest** — `districtId, dayOfWeek`.

Day labels (Arabic), hardcoded locally:

`sunday→الأحد, monday→الإثنين, tuesday→الثلاثاء, wednesday→الأربعاء, thursday→الخميس, friday→الجمعة, saturday→السبت`

## 6. Screens & flows

RTL, Arabic, reusing app conventions: `GetBuilder`, `CustomProgressIndicator`, `CustomErrorWidget`,
`AppColors`, `AppConstants`, `showErrorDialog`/`showSuccessDialog`, `RefreshIndicator`.

### 6.1 Carpool Home (`carpool_home_screen`, `CarpoolController`)

- On init: load districts (cached) + `GET offers/me`.
- Status badge: **"عرضك نشط ✓"** if an active offer exists, else **"لا يوجد عرض بعد"**.
- Two large cards:
  - **أنا سائق** → if an active offer exists go to **My Offer**, else **Driver Setup**.
  - **أبحث عن مشوار** → **Passenger Search**.
- Loading/error/refresh states like `streak_board_tab`.

### 6.2 Driver Setup wizard (`driver_setup_screen`, `DriverSetupController`)

Three steps (stepper or paged), with a Back/Next footer.

1. **الجدول الأسبوعي** — 7 day rows (Sun–Sat, Arabic). Toggling a day on reveals a 24-hour time
   picker; store as `"HH:MM"` (zero-padded, e.g. `08:00`). At least one day required.
2. **خط السير** — searchable district multi-select (client-side filter over cached districts).
   Selected districts show in a **`ReorderableListView`**; drag to set order → sent as `order` 0..n.
   Destination **كلية الصيدلة - جامعة الإسكندرية** shown read-only, pinned at the end. At least one
   checkpoint required.
3. **ملاحظات (اختياري)** — free text, **≤500 chars**, with optional quick-insert chips
   ("سيدات فقط", "مقعدان متاحان").

Submit → `POST /offers/me` → `showSuccessDialog` ("تم نشر رحلتك") → pop back to Carpool Home and
refresh. Edit mode pre-fills all three steps from the existing offer and submits the same body
(POST/PATCH equivalent).

### 6.3 My Offer (`my_offer_screen`)

- Shows schedule (days + times), the route as a **route chain** (`route_chain.dart`), and notes.
- **تعديل** → Driver Setup pre-filled.
- **إيقاف العرض** → confirm, then `DELETE /offers/me` → "تم إيقاف عرضك" → back to Home (badge flips
  to "لا يوجد عرض"). `404` here is treated as "already no offer" (non-error).

### 6.4 Passenger Search (`passenger_search_screen`, `PassengerSearchController`)

- Filters: district dropdown (searchable, `nameAr`) + day picker (Arabic labels, defaults to today).
- **بحث** → `GET /offers/search?districtId=&dayOfWeek=`.
- Result cards (`driver_result_card.dart`): avatar + name, arrival time for the chosen day
  (from `scheduleForDay`), route chain with the **passenger's district highlighted**, notes if any,
  and a **تواصل عبر واتساب** button.
- Empty results (`404` or `results:0`) → friendly empty state ("لا يوجد سائقون متاحون…"), not an error.
- **Contact:** tap → `POST /offers/:id/contact {districtId, dayOfWeek}` → open the returned
  `whatsappUrl` via `url_launcher` (`LaunchMode.externalApplication`) with a pre-filled Arabic message
  appended as URL-encoded `?text=`. `404` (driver deactivated between search and contact) → snackbar
  "لم يعد هذا العرض متاحاً" + refresh the list. If WhatsApp can't open → snackbar.

## 7. State, caching, navigation

- **`CarpoolRepo`** holds the endpoints and an **in-memory district cache** (`List<District>?`),
  fetched once per app session and reused by the wizard and search (guide recommends 24h; in-memory
  for the session is enough for v1).
- **`CarpoolController`** (shared) holds districts + my-offer state; registered `fenix: true` so it
  survives navigation across the sub-screens. Sub-controllers `Get.find` the repo/shared controller.
- **Routes** (`app_routes.dart`): `carpoolHomeScreen`, `carpoolDriverSetupScreen`,
  `carpoolMyOfferScreen`, `carpoolSearchScreen`; wired in `app_pages.dart` with a `CarpoolBindings`
  (and per-sub-screen bindings as needed for their controllers).
- **Home entry:** a Carpool card in `home_tab.dart` (fixed height, inserted between
  `GreenPointsSection` and the activities card) → `Get.toNamed(AppRoutes.carpoolHomeScreen)`.

## 8. Validation (client-side, before submit)

| Field | Rule |
|-------|------|
| weeklySchedule | ≥1 enabled day; each has `arrivalTime` |
| arrivalTime | `HH:MM` 24-hour, zero-padded (`08:00`, not `8:00`) |
| checkpoints | ≥1 district |
| notes | ≤500 chars |
| search districtId | required (button disabled until picked) |

## 9. Error handling

- Repos catch `DioException` → throw `MyCustomException(message)` (same pattern as existing repos),
  guarding against non-JSON bodies (don't index `data['message']` on a String).
- Controllers use `setLoading`/`setError` + `showErrorDialog`, matching `streak_board_controller`.
- `404` on **search** and **deactivate** are expected states, not errors (empty / already-gone).
- `401` anywhere → handled globally by the session-expiry interceptor (redirect to login).

## 10. Out of scope (v1)

No in-app seat request/approval; no green points; no push notifications; no trip-history screen for
users; no EN localization; no 6th bottom-nav tab; no map view. "Women only" is free-text notes only.

## 11. Testing checklist

**Driver:** setup with 1 day/1 checkpoint; multi-day + reordered route; edit via the wizard; GET
offers/me populates after setup; deactivate hides from search; invalid time (`8:00`) blocked client-
side; notes >500 blocked.
**Passenger:** search with district+day returns matches; search without day returns all through the
district; own offer never appears; contact returns phone + opens WhatsApp; contact on a
deactivated offer → 404 empty/snackbar.
**Auth:** protected calls without/expired token → redirect to login (via the interceptor).
**RTL:** route chain and pickers render correctly in Arabic RTL.

## 12. Open items

1. Confirm cookie-JWT works on protected carpool routes (impl step 1).
2. Confirm `POST` vs `PATCH` for edit — guide says both work; use `POST` for create and either for
   edit (pick `PATCH` for edit for clarity).
3. Pre-filled WhatsApp message copy (Arabic) — finalize wording during implementation.
