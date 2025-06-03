class ClothingItem {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final List<String> categories;
  final List<String> occasions;

  ClothingItem({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.categories,
    required this.occasions,
  });

  factory ClothingItem.fromMap(Map<String, dynamic> map, String id) {
    return ClothingItem(
      id: id,
      name: map['name'] ?? '',
      description: map['description'],
      imageUrl: map['imageUrl'],
      categories: List<String>.from(map['categories'] ?? []),
      occasions: List<String>.from(map['occasions'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'categories': categories,
      'occasions': occasions,
    };
  }
}
