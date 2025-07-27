class ClothingItem {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final List<String> categories;
  final List<String> occasions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ClothingItem({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.categories,
    required this.occasions,
    this.createdAt,
    this.updatedAt,
  });

  factory ClothingItem.fromMap(Map<String, dynamic> map, String id) {
    return ClothingItem(
      id: id,
      name: map['name'] ?? '',
      description: map['description'],
      imageUrl: map['imageUrl'],
      categories: List<String>.from(map['categories'] ?? []),
      occasions: List<String>.from(map['occasions'] ?? []),
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'categories': categories,
      'occasions': occasions,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ClothingItem copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<String>? categories,
    List<String>? occasions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClothingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      occasions: occasions ?? this.occasions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
