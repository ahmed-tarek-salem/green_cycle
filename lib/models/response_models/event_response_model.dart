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
  final String? location;

  /// Optional photo the admin added. Null when there is none.
  final String? image;

  Event(
      {required this.id,
      required this.name,
      required this.description,
      required this.details,
      required this.date,
      required this.location,
      this.image});
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
        id: map['_id'],
        name: map['name'],
        description: map['description'],
        details: map['details'],
        // The server sends UTC. Shown in the student's own time.
        date: DateTime.tryParse('${map['date']}')?.toLocal(),
        location: map['location'],
        image: _nonEmpty(map['image']));
  }
}

String? _nonEmpty(dynamic value) {
  final s = value?.toString().trim();
  return s == null || s.isEmpty ? null : s;
}
