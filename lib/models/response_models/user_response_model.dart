class UserResponseModel {
  final String status;
  final String? token;
  final UserData data;
  UserResponseModel({
    required this.status,
    required this.token,
    required this.data,
  });

  factory UserResponseModel.fromMap(Map<String, dynamic> map) {
    return UserResponseModel(
      status: map['status'],
      token: map['token'],
      data: UserData.fromMap(map['data']),
    );
  }
}

class UserData {
  final String? name;
  final String? id;
  final int? serialId;
  final int? phone;
  final String? avatar;
  final String? gender;
  final bool? isVerified;
  final bool? isActive;
  final int? totalPoints;

  UserData({
    required this.name,
    required this.id,
    required this.serialId,
    required this.phone,
    required this.avatar,
    required this.gender,
    this.totalPoints,
    this.isVerified,
    this.isActive,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['user']['name'],
      id: map['user']['_id'],
      serialId: map['user']['serialId'],
      phone: map['user']['phone'],
      avatar: map['user']['avatar'],
      gender: map['user']['gender'],
      isVerified: map['user']['IDVerified'],
      isActive: map['user']['active'],
    );
  }
}
