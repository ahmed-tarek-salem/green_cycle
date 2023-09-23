class SignUpRequestModel {
  String name;
  String phone;
  String gender;
  String password;
  String passwordConfirm;
  SignUpRequestModel({
    required this.name,
    required this.phone,
    required this.gender,
    required this.password,
    required this.passwordConfirm,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'gender': gender,
      'password': password,
      'passwordConfirm': passwordConfirm,
    };
  }
}
