class LoginRequestModel {
  String phone;
  String password;
  LoginRequestModel({
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phone': phone,
      'password': password,
    };
  }
}
