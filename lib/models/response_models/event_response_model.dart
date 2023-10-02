class EventesResponseModel {
  final List<Event> events;

  EventesResponseModel({required this.events});

  factory EventesResponseModel.fromMap(Map<String, dynamic> map) {
    return EventesResponseModel(
        events: List<Event>.from(
            map['data']['events'].map((eventMap) => Event.fromMap(eventMap))));
  }
}

class Event {
  final String id;
  final String? name;
  final String? description;
  final String? details;
  final DateTime? date;
  final String location;

  Event(
      {required this.id,
      required this.name,
      required this.description,
      required this.details,
      required this.date,
      required this.location});
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
        id: map['_id'],
        name: map['name'],
        description: map['description'],
        details: map['details'],
        date: DateTime.parse(map['date']),
        location: map['location']);
  }
}
