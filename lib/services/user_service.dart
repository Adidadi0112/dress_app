import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dress_app/models/friend.dart';

class UserService {
  static const String baseUrl =
      'https://x8ki-letl-twmt.n7.xano.io/api:8aUUoezg';

  // Fetch all users from the API
  Future<List<Friend>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((user) => Friend.fromApiJson(user)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  // Get a specific user by ID
  Future<Friend> getUserById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Friend.fromApiJson(data);
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  // In a real app, you would have methods to add, update, and delete users
  // For now, we'll just implement the read functionality
}
