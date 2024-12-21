import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserLocal {
  static final storage = FlutterSecureStorage();

  static Future<void> logout() async {
    try {
      await storage.deleteAll();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  static Future<Map<String, String>> getUserInfo() async {
    try {
      String userId = await storage.read(key: 'userId') ?? '';
      String refreshToken = await storage.read(key: 'refreshToken') ?? '';
      String accessToken = await storage.read(key: 'accessToken') ?? '';
      String email = await storage.read(key: 'email') ?? '';
      String name = await storage.read(key: 'name') ?? '';

      Map<String, String> data = {
        'userId': userId,
        'refreshToken': refreshToken,
        'accessToken': accessToken,
        'email': email,
        'name': name
      };
      return data;
    } catch (e) {
      print('Error retrieving user info: $e');
      return {};
    }
  }
}
