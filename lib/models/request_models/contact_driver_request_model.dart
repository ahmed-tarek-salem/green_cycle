class ContactDriverRequest {
  final String districtId;
  final String dayOfWeek;

  ContactDriverRequest({required this.districtId, required this.dayOfWeek});

  Map<String, dynamic> toMap() =>
      {'districtId': districtId, 'dayOfWeek': dayOfWeek};
}
