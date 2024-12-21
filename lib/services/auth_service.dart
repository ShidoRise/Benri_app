import 'package:benri_app/services/user_local.dart';
import 'package:benri_app/utils/constants/constant.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final storage = FlutterSecureStorage();
  static final String baseUrl = dotenv.get('API_URL');
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'x-api-key': Constants.apiKey,
          'content-type': 'application/json'
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['metadata'];
        final user = responseData['user'];
        final tokens = responseData['tokens'];
        final email = user['user_email'];
        final userId = user['_id'];
        final name = user['user_name'];

        await _saveUserData(
            userId, tokens['refreshToken'], tokens['accessToken'], email, name);
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> preSignUp(String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pre_signup'),
        headers: {
          'x-api-key': Constants.apiKey,
          'content-type': 'application/json'
        },
        body: jsonEncode({"email": email, "password": password, "name": name}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('signup error: $e');
      return false;
    }
  }

  Future<bool> verifyOTP(
      String email, String password, String name, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify_otp_and_signup'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': Constants.apiKey,
        },
        body: jsonEncode({
          "email": email,
          "password": password,
          "name": name,
          "otp": otp,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['metadata'];
        final user = responseData['user'];
        final tokens = responseData['tokens'];
        final email = user['user_email'];
        await _saveUserData(user['_id'], tokens['refreshToken'],
            tokens['accessToken'], email, user['user_name']);
        return true;
      } else {
        print('Error verifying OTP: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    }
  }

  Future<void> _saveUserData(String userId, String refreshToken,
      String accessToken, String email, String name) async {
    try {
      await storage.write(key: 'userId', value: userId);
      await storage.write(key: 'refreshToken', value: refreshToken);
      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'name', value: name);
      printData();
    } catch (e) {
      print('Failed to save user data: $e');
    }
  }

  Future<Map<String, String?>> printData() async {
    try {
      String? userId = await storage.read(key: 'userId');
      String? refreshToken = await storage.read(key: 'refreshToken');
      String? accessToken = await storage.read(key: 'accessToken');
      String? email = await storage.read(key: 'email');
      print(userId);
      print(refreshToken);
      print(accessToken);
      print(email);

      return {
        'userId': userId,
        'refreshToken': refreshToken,
        'accessToken': accessToken,
        'email': email,
      };
    } catch (e) {
      print('Failed to retrieve user data: $e');
      return {};
    }
  }

  static Future<bool> changePassword(oldPass, newPass) async {
    final Map<String, String> userLocal = await UserLocal.getUserInfo();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/change_password'),
        headers: {
          'x-api-key': Constants.apiKey,
          'authorization': userLocal['accessToken'] ?? '',
          'x-client-id': userLocal['userId'] ?? '',
          'content-type': 'application/json'
        },
        body: jsonEncode({"oldPassword": oldPass, "newPassword": newPass}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
