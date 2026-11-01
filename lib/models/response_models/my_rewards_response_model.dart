/// The signed-in student's rewards progress from `GET /rewards/me`.
///
/// Only the fields the app shows today are parsed. Level titles, ranges and
/// rewards are edited by the college from the dashboard, so nothing here is
/// hardcoded.
class MyRewardsResponseModel {
  final int totalPoints;
  final RewardLevel? level;

  /// Null on the last level.
  final RewardLevel? nextLevel;
  final int pointsToNextLevel;

  const MyRewardsResponseModel({
    required this.totalPoints,
    required this.level,
    required this.nextLevel,
    required this.pointsToNextLevel,
  });

  factory MyRewardsResponseModel.fromMap(Map<String, dynamic> map) {
    final data = map['data'] as Map<String, dynamic>? ?? const {};
    return MyRewardsResponseModel(
      totalPoints: _toInt(data['totalPoints']),
      level: RewardLevel.maybeFromMap(data['level']),
      nextLevel: RewardLevel.maybeFromMap(data['nextLevel']),
      pointsToNextLevel: _toInt(data['pointsToNextLevel']),
    );
  }

  bool get isLastLevel => level != null && nextLevel == null;

  /// Share of the way from the current level to the next one, from 0 to 1.
  /// Full on the last level.
  double get levelProgress {
    final current = level;
    final next = nextLevel;
    if (current == null) return 0;
    if (next == null) return 1;
    final span = next.minPoints - current.minPoints;
    if (span <= 0) return 1;
    return ((totalPoints - current.minPoints) / span).clamp(0.0, 1.0);
  }
}

class RewardLevel {
  final int order;
  final String titleAr;
  final String emoji;
  final int minPoints;

  /// Null on the last level, which has no upper bound.
  final int? maxPoints;
  final String rewardAr;

  const RewardLevel({
    this.order = 0,
    required this.titleAr,
    required this.emoji,
    required this.minPoints,
    this.maxPoints,
    required this.rewardAr,
  });

  static RewardLevel? maybeFromMap(Object? value) =>
      value is Map<String, dynamic> ? RewardLevel.fromMap(value) : null;

  factory RewardLevel.fromMap(Map<String, dynamic> map) {
    final maxPoints = map['maxPoints'];
    return RewardLevel(
      order: _toInt(map['order']),
      titleAr: map['titleAr'] ?? '',
      emoji: map['emoji'] ?? '',
      minPoints: _toInt(map['minPoints']),
      maxPoints: maxPoints is num ? maxPoints.toInt() : null,
      rewardAr: map['rewardAr'] ?? '',
    );
  }
}

int _toInt(Object? value) => value is num ? value.toInt() : 0;
