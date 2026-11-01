import 'package:green_cycle/utilities/global/app_environment.dart';

class AppEndpoints {
  /// Resolved live from the global [appEnvironment] switch, so flipping the
  /// environment re-points every endpoint below without any other change.
  static String get baseUrl => appEnvironment.baseUrl;

  static String get login => '${baseUrl}auth/log-in';
  static String get signup => '${baseUrl}auth/sign-up';
  static String get veifyOtp => '${baseUrl}auth/verify-otp';
  static String get locations => '${baseUrl}map';
  static String get faqs => '${baseUrl}faqs';
  static String get user => '${baseUrl}users/me';
  static String get events => '${baseUrl}events';
  static String get activities => '${baseUrl}activities';
  static String get feedback => '${baseUrl}feedback';
  static String get surveys => '${baseUrl}questionnaires';
  static String get surveyResponse => '${baseUrl}responses/response';
  static String get leaderboard => '${baseUrl}users/leaderboard';
  static String get leaderboardMe => '${baseUrl}users/leaderboard/me';
  static String get rewards => '${baseUrl}rewards';
  static String get rewardsMe => '${baseUrl}rewards/me';
  static String get appSettings => '${baseUrl}app-settings';
  static String get carpoolDistricts => '${baseUrl}carpool/districts';
  static String get carpoolDays => '${baseUrl}carpool/days';
  static String get carpoolOfferMe => '${baseUrl}carpool/offers/me';
  static String get carpoolSearch => '${baseUrl}carpool/offers/search';
  static String carpoolContact(String offerId) =>
      '${baseUrl}carpool/offers/$offerId/contact';
}
