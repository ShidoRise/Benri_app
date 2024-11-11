import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserLocal {
  static final storage = FlutterSecureStorage();

  static Future<Map<String, String>> getUserInfo() async {
    String userId = await storage.read(key: 'userId') ?? '';
    String refreshToken = await storage.read(key: 'refreshToken') ?? '';
    String accessToken = await storage.read(key: 'accessToken') ?? '';
    Map<String, String> data = {
      'userId': userId,
      'refreshToken': refreshToken,
      'accessToken': accessToken,
    };
    return data;
  }
}
