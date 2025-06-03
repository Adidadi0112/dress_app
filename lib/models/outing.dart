import 'package:dress_app/models/clothing_item.dart';

class Outing {
  final String id;
  final String location;
  final DateTime date;
  final List<String> participants;
  final List<ClothingItem> wornItems;
  final String? foodNotes;
  final bool isPast;

  Outing({
    required this.id,
    required this.location,
    required this.date,
    required this.participants,
    required this.wornItems,
    this.foodNotes,
    required this.isPast,
  });

  factory Outing.fromMap(Map<String, dynamic> map, String id) {
    return Outing(
      id: id,
      location: map['location'] ?? '',
      date: DateTime.parse(map['date']),
      participants: List<String>.from(map['participants'] ?? []),
      wornItems:
          (map['wornItems'] as List?)
              ?.map(
                (item) => ClothingItem.fromMap(
                  item as Map<String, dynamic>,
                  item['id'] as String,
                ),
              )
              .toList() ??
          [],
      foodNotes: map['foodNotes'],
      isPast: map['isPast'] ?? false,
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
    };
  }
}
