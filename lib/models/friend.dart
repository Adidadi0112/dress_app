import 'package:flutter/material.dart';

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
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      isConfirmed: json['isConfirmed'] ?? true,
    );
  }
}
