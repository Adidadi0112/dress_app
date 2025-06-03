import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenController {
  final storage = const FlutterSecureStorage();

  Future<void> saveAuthToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getAuthToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<bool> removeAuthToken() async {
    await storage.deleteAll();
    return true;
  }
}
