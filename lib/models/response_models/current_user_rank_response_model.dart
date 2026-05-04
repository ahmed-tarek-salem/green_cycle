class CurrentUserRankResponseModel {
  final String status;
  final int rank;
  final int totalPoints;
  final int tiedWith;

  CurrentUserRankResponseModel({
    required this.status,
    required this.rank,
    required this.totalPoints,
    required this.tiedWith,
  });

  factory CurrentUserRankResponseModel.fromMap(Map<String, dynamic> map) {
    final data = map['data'] as Map<String, dynamic>? ?? const {};
    return CurrentUserRankResponseModel(
      status: map['status'] ?? '',
      rank: data['rank'] ?? 0,
      totalPoints: data['totalPoints'] ?? 0,
      tiedWith: data['tiedWith'] ?? 0,
    );
  }
}
