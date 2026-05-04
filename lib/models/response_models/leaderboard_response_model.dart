class LeaderboardResponseModel {
  final String status;
  final int results;
  final LeaderboardPagination pagination;
  final List<LeaderboardEntry> leaderboard;

  LeaderboardResponseModel({
    required this.status,
    required this.results,
    required this.pagination,
    required this.leaderboard,
  });

  factory LeaderboardResponseModel.fromMap(Map<String, dynamic> map) {
    final data = map['data'] as Map<String, dynamic>? ?? const {};
    final entries = (data['leaderboard'] as List?) ?? const [];
    return LeaderboardResponseModel(
      status: map['status'] ?? '',
      results: map['results'] ?? 0,
      pagination:
          LeaderboardPagination.fromMap(map['pagination'] as Map<String, dynamic>? ?? const {}),
      leaderboard: entries
          .map((e) => LeaderboardEntry.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class LeaderboardPagination {
  final int page;
  final int limit;
  final int totalUsers;
  final int totalPages;

  LeaderboardPagination({
    required this.page,
    required this.limit,
    required this.totalUsers,
    required this.totalPages,
  });

  factory LeaderboardPagination.fromMap(Map<String, dynamic> map) {
    return LeaderboardPagination(
      page: map['page'] ?? 1,
      limit: map['limit'] ?? 0,
      totalUsers: map['totalUsers'] ?? 0,
      totalPages: map['totalPages'] ?? 0,
    );
  }
}

class LeaderboardEntry {
  final String? id;
  final int rank;
  final String? name;
  final String? avatar;
  final int totalPoints;
  final int? serialId;

  LeaderboardEntry({
    required this.id,
    required this.rank,
    required this.name,
    required this.avatar,
    required this.totalPoints,
    required this.serialId,
  });

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      id: map['_id'],
      rank: map['rank'] ?? 0,
      name: map['name'],
      avatar: map['avatar'],
      totalPoints: map['totalPoints'] ?? 0,
      serialId: map['serialId'],
    );
  }
}
