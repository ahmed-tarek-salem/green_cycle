class EventResponseModel {
  final String id;
  final String name;
  final String description;
  final String details;
  final DateTime date;
  final String location;

  EventResponseModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.details,
      required this.date,
      required this.location});
  factory EventResponseModel.fromMap(Map<String, dynamic> map) {
    return EventResponseModel(
        id: map['data']['docs']['_id'],
        name: map['data']['docs']['name'],
        description: map['data']['docs']['description'],
        details: map['data']['docs']['details'],
        date: map['data']['docs']['date'],
        location: map['data']['docs']['location']);
  }
}
