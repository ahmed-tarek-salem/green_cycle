class ErrorResponseModel {
  final String message;

  ErrorResponseModel({required this.message});
  factory ErrorResponseModel.fromMap(Map<String, dynamic> map) {
    return ErrorResponseModel(message: map['message']);
  }
}
