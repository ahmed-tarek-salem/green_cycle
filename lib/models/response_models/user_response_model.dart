import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserResponseModel {
  final String status;
  final String token;
  final Map<String, dynamic> data;
  UserResponseModel({
    required this.status,
    required this.token,
    required this.data,
  });

  factory UserResponseModel.fromMap(Map<String, dynamic> map) {
    return UserResponseModel(
      status: map['status'],
      token: map['token'],
      data: Map<String, dynamic>.from((map['data'] as Map<String, dynamic>)),
    );
  }
}

class UserData {
  final String name;
  final String id;
  final String phone;
  final String avatar;
  final String gender;
  final bool? isVerified;
  final bool? isActive;

  UserData({
    required this.name,
    required this.id,
    required this.phone,
    required this.avatar,
    required this.gender,
    this.isVerified,
    this.isActive,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
        name: map['data']['user'],
        id: map['data']['id'],
        phone: map['data']['phone'],
        avatar: map['data']['avatar'],
        gender: map['data']['gender']);
  }
}
