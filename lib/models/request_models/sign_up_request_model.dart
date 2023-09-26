import 'dart:developer';

import 'package:dio/dio.dart';

class SignUpRequestModel {
  String name;
  String phone;
  String gender;
  String password;
  String passwordConfirm;
  final MultipartFile image;

  SignUpRequestModel({
    required this.name,
    required this.phone,
    required this.gender,
    required this.password,
    required this.passwordConfirm,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    log(image.filename.toString());
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'gender': gender,
      'password': password,
      'passwordConfirm': passwordConfirm,
      'IDCard': image,
    };
  }
}
