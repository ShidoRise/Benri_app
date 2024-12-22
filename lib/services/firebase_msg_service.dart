import 'package:benri_app/services/user_local.dart';
import 'package:benri_app/utils/constants/constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseMsg {
  static final String baseUrl = dotenv.get('API_URL');
  static Future<void> saveTokenToDatabase(String userId) async {
    String? token = await FirebaseMessaging.instance.getToken();
    final Map<String, String> userLocal = await UserLocal.getUserInfo();
    if (token != null) {
      await http.post(
        Uri.parse('$baseUrl/user/save-token'), // Thay đổi URL cho phù hợp
        headers: {
          'Content-Type': 'application/json',
          'authorization': userLocal['accessToken'] ?? '',
          'x-client-id': userLocal['userId'] ?? '',
          'content-type': 'application/json'
        },
        body: json.encode({
          'fcmToken': token,
        }),
      );

      print('====$token');
    }
  }

  void onUserLogin(String userId) {
    saveTokenToDatabase(userId);
  }
}
