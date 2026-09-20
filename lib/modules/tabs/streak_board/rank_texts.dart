import 'package:green_cycle/models/response_models/leaderboard_response_model.dart';
import 'package:green_cycle/utilities/global/points_label.dart';

/// The line under the student's rank on the leaderboard.
///
/// [rank] and [tiedWith] come from the my-rank endpoint. The two place
/// scores come from the loaded top 3 and may be missing if that list is
/// short, in which case the message drops the exact gap.
String rankMessage({
  required int rank,
  required int tiedWith,
  required int points,
  int? firstPlacePoints,
  int? thirdPlacePoints,
}) {
  if (rank <= 0) return 'اجمع المزيد من النقاط للتقدم في الترتيب!';

  if (rank == 1) {
    if (tiedWith > 1) {
      return 'تتشارك المركز الأول مع ${_othersLabel(tiedWith - 1)}. '
          'اجمع المزيد من النقاط لتنفرد بالصدارة!';
    }
    return 'أنت في المركز الأول! حافظ على صدارتك بالمشاركة في الأنشطة البيئية';
  }

  if (rank <= 3) {
    final gap = _gap(firstPlacePoints, points);
    final action =
        gap == null ? 'اجمع المزيد من النقاط' : 'باقي ${pointsLabel(gap)}';
    return 'أنت ضمن أفضل 3 طلاب! $action للوصول إلى المركز الأول';
  }

  final gap = _gap(thirdPlacePoints, points);
  final action =
      gap == null ? 'اجمع المزيد من النقاط' : 'باقي ${pointsLabel(gap)}';
  return '$action لتدخل قائمة أفضل 3 طلاب';
}

/// Rank to print on a podium card: one more than the number of loaded
/// students with a strictly higher score. This is how the my-rank endpoint
/// counts, so the podium and "your rank" agree when scores tie. The
/// backend's own `rank` field uses dense ranking and would not.
int podiumRank(List<LeaderboardEntry> top, LeaderboardEntry entry) =>
    1 + top.where((other) => other.totalPoints > entry.totalPoints).length;

int? _gap(int? target, int points) {
  if (target == null) return null;
  final gap = target - points;
  return gap > 0 ? gap : null;
}

String _othersLabel(int others) {
  if (others == 1) return 'مستخدم آخر';
  if (others == 2) return 'مستخدمَين آخرَين';
  final lastTwoDigits = others % 100;
  if (lastTwoDigits >= 3 && lastTwoDigits <= 10) {
    return '$others مستخدمين آخرين';
  }
  return '$others مستخدماً آخر';
}
