class Friend {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isConfirmed;

  Friend({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.isConfirmed = true,
  });

  Friend copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    bool? isConfirmed,
  }) {
    return Friend(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'isConfirmed': isConfirmed,
    };
  }

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      isConfirmed: json['isConfirmed'] ?? true,
    );
  }

  // Create a Friend from the API response
  factory Friend.fromApiJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: null, // API doesn't provide avatar URL
      isConfirmed: true, // All users from API are considered confirmed
    );
  }

  // Firestore methods
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'isConfirmed': isConfirmed,
    };
  }

  factory Friend.fromFirestore(Map<String, dynamic> data, String id) {
    return Friend(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'],
      isConfirmed: data['isConfirmed'] ?? true,
    );
  }
}
