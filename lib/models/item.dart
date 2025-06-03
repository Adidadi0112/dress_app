class Item {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final List<String>? categories;
  final List<String>? occasions;

  Item({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.categories,
    this.occasions,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      categories: json['category'] != null ? [json['category']] : null,
      occasions: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': categories?.firstOrNull,
    };
  }

  @override
  String toString() {
    return 'Item(id: $id, name: $name, categories: $categories)';
  }
}
