import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController {
  final storage = const FlutterSecureStorage();

  Future<void> saveData(Map<String, String> data) async {
    await storage.write(key: 'email', value: data['email']);
    await storage.write(key: 'password', value: data['password']);
  }

  Future<Map<String, String?>> readData() async {
    return {
      "email": await storage.read(key: "email"),
      "password": await storage.read(key: "password"),
    };
  }

  Future<void> removeData() async {
    await storage.deleteAll();
  }
}
