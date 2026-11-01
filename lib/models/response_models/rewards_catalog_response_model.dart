import 'package:green_cycle/models/response_models/my_rewards_response_model.dart';

/// The public rewards catalog from `GET /rewards`.
///
/// The college edits every name, number and range from the dashboard, so the
/// app only renders what arrives here. Items switched off by the college are
/// dropped, and lists follow the order the college set.
class RewardsCatalogResponseModel {
  final RewardsConfig config;
  final List<RewardAction> actions;
  final List<RewardLevel> levels;
  final List<RewardPrize> prizes;

  const RewardsCatalogResponseModel({
    required this.config,
    required this.actions,
    required this.levels,
    required this.prizes,
  });

  factory RewardsCatalogResponseModel.fromMap(Map<String, dynamic> map) {
    final data = map['data'] as Map<String, dynamic>? ?? const {};
    return RewardsCatalogResponseModel(
      config: RewardsConfig.fromMap(
        data['config'] as Map<String, dynamic>? ?? const {},
      ),
      actions: _activeItems(data['actions']).map(RewardAction.fromMap).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
      levels: _activeItems(data['levels']).map(RewardLevel.fromMap).toList()
        ..sort(
          (a, b) => a.order != b.order
              ? a.order.compareTo(b.order)
              : a.minPoints.compareTo(b.minPoints),
        ),
      prizes: _activeItems(data['prizes']).map(RewardPrize.fromMap).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
    );
  }
}

enum PointsMode { fixed, perUnit, variants }

class RewardAction {
  final String slug;
  final String nameAr;
  final String descriptionAr;

  /// How the student proves the activity, for example "صورة داخل الكلية".
  final String verificationAr;
  final PointsMode pointsMode;

  /// The fixed amount, or the amount per unit in [PointsMode.perUnit].
  final int points;
  final String unitLabelAr;
  final List<PointVariant> variants;
  final String icon;

  /// Days the student must wait before repeating it. Zero means no wait.
  final int cooldownDays;
  final int sortOrder;

  /// Who records it: `student` from the app, `admin` from the dashboard, or
  /// `auto` by the system (carpooling).
  final String submittedBy;

  bool get isStudentSubmittable => submittedBy == 'student';

  const RewardAction({
    required this.slug,
    required this.nameAr,
    required this.descriptionAr,
    required this.verificationAr,
    required this.pointsMode,
    required this.points,
    required this.unitLabelAr,
    required this.variants,
    required this.icon,
    required this.cooldownDays,
    required this.sortOrder,
    required this.submittedBy,
  });

  factory RewardAction.fromMap(Map<String, dynamic> map) {
    return RewardAction(
      slug: map['slug'] ?? '',
      nameAr: map['nameAr'] ?? '',
      descriptionAr: map['descriptionAr'] ?? '',
      verificationAr: map['verificationAr'] ?? '',
      pointsMode: switch (map['pointsMode']) {
        'per_unit' => PointsMode.perUnit,
        'variants' => PointsMode.variants,
        _ => PointsMode.fixed,
      },
      points: _toInt(map['points']),
      unitLabelAr: map['unitLabelAr'] ?? '',
      variants: _mapItems(
        map['pointVariants'],
      ).map(PointVariant.fromMap).toList(),
      icon: map['icon'] ?? '',
      cooldownDays: _toInt(map['cooldownDays']),
      sortOrder: _toInt(map['sortOrder']),
      submittedBy: map['submittedBy'] ?? 'student',
    );
  }
}

class PointVariant {
  final String key;
  final String labelAr;
  final int points;

  const PointVariant({
    required this.key,
    required this.labelAr,
    required this.points,
  });

  factory PointVariant.fromMap(Map<String, dynamic> map) {
    return PointVariant(
      key: map['key'] ?? '',
      labelAr: map['labelAr'] ?? '',
      points: _toInt(map['points']),
    );
  }
}

class RewardPrize {
  final String titleAr;
  final String descriptionAr;
  final String icon;
  final int sortOrder;

  const RewardPrize({
    required this.titleAr,
    required this.descriptionAr,
    required this.icon,
    required this.sortOrder,
  });

  factory RewardPrize.fromMap(Map<String, dynamic> map) {
    return RewardPrize(
      titleAr: map['titleAr'] ?? '',
      descriptionAr: map['descriptionAr'] ?? '',
      icon: map['icon'] ?? '',
      sortOrder: _toInt(map['sortOrder']),
    );
  }
}

/// Bonuses the server grants on its own, with no submission from the student.
class RewardsConfig {
  final int signupPoints;
  final int firstGreenActivityPoints;
  final int firstMilestoneCount;
  final int firstMilestonePoints;
  final int repeatingMilestoneCount;
  final int repeatingMilestonePoints;

  const RewardsConfig({
    required this.signupPoints,
    required this.firstGreenActivityPoints,
    required this.firstMilestoneCount,
    required this.firstMilestonePoints,
    required this.repeatingMilestoneCount,
    required this.repeatingMilestonePoints,
  });

  factory RewardsConfig.fromMap(Map<String, dynamic> map) {
    return RewardsConfig(
      signupPoints: _toInt(map['signupPoints']),
      firstGreenActivityPoints: _toInt(map['firstGreenActivityPoints']),
      firstMilestoneCount: _toInt(map['firstMilestoneCount']),
      firstMilestonePoints: _toInt(map['firstMilestonePoints']),
      repeatingMilestoneCount: _toInt(map['repeatingMilestoneCount']),
      repeatingMilestonePoints: _toInt(map['repeatingMilestonePoints']),
    );
  }
}

Iterable<Map<String, dynamic>> _mapItems(Object? list) =>
    list is List ? list.whereType<Map<String, dynamic>>() : const [];

Iterable<Map<String, dynamic>> _activeItems(Object? list) =>
    _mapItems(list).where((item) => item['active'] != false);

int _toInt(Object? value) => value is num ? value.toInt() : 0;
