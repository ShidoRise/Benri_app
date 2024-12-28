import 'package:benri_app/services/auth_service.dart';
import 'package:benri_app/services/family_service.dart';

class UserLocal {
  UserLocal._();

  static Future<void> logout() async {
    try {
      await AuthService.storage.deleteAll();
      await FamilyService.storage.deleteAll();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  static Future<Map<String, String>> getUserInfo() async {
    try {
      String userId = await AuthService.storage.read(key: 'userId') ?? '';
      String refreshToken =
          await AuthService.storage.read(key: 'refreshToken') ?? '';
      String accessToken =
          await AuthService.storage.read(key: 'accessToken') ?? '';
      String email = await AuthService.storage.read(key: 'email') ?? '';
      String name = await AuthService.storage.read(key: 'name') ?? '';

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
