import 'package:green_cycle/models/response_models/my_rewards_response_model.dart';
import 'package:green_cycle/models/response_models/rewards_catalog_response_model.dart';
import 'package:green_cycle/utilities/global/points_label.dart';

/// What an action is worth, one entry per amount the student can earn.
List<String> actionPointsTexts(RewardAction action) {
  switch (action.pointsMode) {
    case PointsMode.variants when action.variants.isNotEmpty:
      return [
        for (final variant in action.variants)
          '${variant.labelAr}: ${pointsLabel(variant.points)}',
      ];
    case PointsMode.perUnit:
      final unit = action.unitLabelAr.isEmpty ? 'وحدة' : action.unitLabelAr;
      return ['${pointsLabel(action.points)} لكل $unit'];
    default:
      return [pointsLabel(action.points)];
  }
}

/// How often an action can be repeated, or null when there is no wait.
String? cooldownText(int days) {
  if (days <= 0) return null;
  if (days == 1) return 'مرة واحدة كل يوم';
  if (days == 2) return 'مرة واحدة كل يومين';
  final lastTwoDigits = days % 100;
  final word = lastTwoDigits >= 3 && lastTwoDigits <= 10 ? 'أيام' : 'يوماً';
  return 'مرة واحدة كل $days $word';
}

String levelRangeText(RewardLevel level) {
  final max = level.maxPoints;
  if (max == null) return '${pointsLabel(level.minPoints)} فأكثر';
  return 'من ${level.minPoints} إلى ${pointsLabel(max)}';
}

/// Index of the highest level [points] reaches, or -1 without levels.
/// [levels] must be sorted from lowest to highest.
int currentLevelIndex(List<RewardLevel> levels, int points) =>
    levels.lastIndexWhere((level) => points >= level.minPoints);

/// An activities count in the form that follows "إكمال" or "كل".
String activitiesLabel(int count) {
  if (count == 1) return 'نشاط واحد';
  if (count == 2) return 'نشاطين';
  final lastTwoDigits = count % 100;
  if (lastTwoDigits >= 3 && lastTwoDigits <= 10) return '$count أنشطة';
  if (lastTwoDigits >= 11) return '$count نشاطاً';
  return '$count نشاط';
}

/// The automatic bonuses worth showing. A bonus with no points, or a
/// milestone with no count, was switched off by the college.
List<String> bonusLines(RewardsConfig config) => [
      if (config.signupPoints > 0)
        'عند إنشاء حسابك: ${pointsLabel(config.signupPoints)}',
      if (config.firstGreenActivityPoints > 0)
        'أول نشاط بيئي معتمد: ${pointsLabel(config.firstGreenActivityPoints)}',
      if (config.firstMilestoneCount > 0 && config.firstMilestonePoints > 0)
        'عند إكمال ${activitiesLabel(config.firstMilestoneCount)}: '
            '${pointsLabel(config.firstMilestonePoints)}',
      if (config.repeatingMilestoneCount > 0 &&
          config.repeatingMilestonePoints > 0)
        'كل ${activitiesLabel(config.repeatingMilestoneCount)}: '
            '${pointsLabel(config.repeatingMilestonePoints)}',
    ];
