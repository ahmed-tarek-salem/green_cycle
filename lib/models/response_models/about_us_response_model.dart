/// The "About us" page as the admin edits it from the dashboard.
class AboutUsResponseModel {
  final String title;
  final String text;
  final List<TeamMember> members;

  AboutUsResponseModel({
    required this.title,
    required this.text,
    required this.members,
  });

  factory AboutUsResponseModel.fromMap(Map<String, dynamic> map) {
    final docs = map['data']?['aboutUs'];
    final Map<String, dynamic> doc = docs is List && docs.isNotEmpty
        ? Map<String, dynamic>.from(docs.first)
        : {};

    // Old documents keep the team under "users"; newer ones under "members".
    final members = [
      ...?(doc['members'] as List?),
      ...?(doc['users'] as List?),
    ]
        .map((e) => TeamMember.fromMap(Map<String, dynamic>.from(e)))
        .where((m) => m.name.isNotEmpty)
        .toList();

    return AboutUsResponseModel(
      title: _text(doc['title']) ?? 'من نحن',
      text: _text(doc['aboutUs']) ?? '',
      members: members,
    );
  }
}

class TeamMember {
  final String name;

  /// Prefix such as "د/". Empty when none.
  final String title;
  final String role;
  final String? photo;

  TeamMember({
    required this.name,
    required this.title,
    required this.role,
    required this.photo,
  });

  /// Name with its prefix, e.g. "د/ أحمد".
  String get displayName => title.isEmpty ? name : '$title $name';

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    // A legacy entry may only link a user document.
    final user = map['user'] is Map ? map['user'] as Map : const {};
    return TeamMember(
      name: _text(map['name']) ?? _text(user['name']) ?? '',
      title: _text(map['title']) ?? '',
      role: _text(map['role']) ?? '',
      photo: _text(map['photo']) ?? _text(user['photo']),
    );
  }
}

String? _text(dynamic value) {
  final s = value?.toString().trim();
  return s == null || s.isEmpty ? null : s;
}
