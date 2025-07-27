import 'package:dress_app/models/item.dart';

class Meeting {
  final String id;
  final String location;
  final DateTime date;
  final List<String> participants;
  final List<Item> wornItems;
  final String? foodNotes;
  final bool isPast;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Meeting({
    required this.id,
    required this.location,
    required this.date,
    required this.participants,
    required this.wornItems,
    this.foodNotes,
    required this.isPast,
    this.createdAt,
    this.updatedAt,
  });

  // Create a copy with updated fields
  Meeting copyWith({
    String? id,
    String? location,
    DateTime? date,
    List<String>? participants,
    List<Item>? wornItems,
    String? foodNotes,
    bool? isPast,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Meeting(
      id: id ?? this.id,
      location: location ?? this.location,
      date: date ?? this.date,
      participants: participants ?? this.participants,
      wornItems: wornItems ?? this.wornItems,
      foodNotes: foodNotes ?? this.foodNotes,
      isPast: isPast ?? this.isPast,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Meeting.fromMap(Map<String, dynamic> map, String id) {
    return Meeting(
      id: id,
      location: map['location'] ?? '',
      date: DateTime.parse(map['date']),
      participants: List<String>.from(map['participants'] ?? []),
      wornItems: (map['wornItems'] as List?)
              ?.map(
                (item) => Item.fromMap(
                  item as Map<String, dynamic>,
                  item['id'] ?? '',
                ),
              )
              .toList() ??
          [],
      foodNotes: map['foodNotes'],
      isPast: map['isPast'] ?? false,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'date': date.toIso8601String(),
      'participants': participants,
      'wornItems': wornItems.map((item) => item.toMap()).toList(),
      'foodNotes': foodNotes,
      'isPast': isPast,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  // Helper method to check if meeting is actually past based on current time
  bool get isActuallyPast {
    final now = DateTime.now();
    return date.isBefore(now);
  }

  // Helper method to get participant count
  int get participantCount => participants.length;

  // Helper method to get worn items count
  int get wornItemsCount => wornItems.length;

  @override
  String toString() {
    return 'Meeting(id: $id, location: $location, date: $date, participants: ${participants.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Meeting && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
