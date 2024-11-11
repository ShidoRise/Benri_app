import 'package:benri_app/utils/constants/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final storage = FlutterSecureStorage();
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.41.106:3056/v1/api/login'),
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
        final userId = user['_id'];

        await _saveUserData(
            userId, tokens['refreshToken'], tokens['accessToken']);
        return true;
      } else {
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
        Uri.parse('http://192.168.41.106:3056/v1/api/pre_signup'),
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
        Uri.parse('http://192.168.41.106:3056/v1/api/verify_otp_and_signup'),
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
        print('Verifying OTP: $otp');
        await _saveUserData(
            user['_id'], tokens['refreshToken'], tokens['accessToken']);
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

  Future<void> _saveUserData(
      String userId, String refreshToken, String accessToken) async {
    try {
      await storage.write(key: 'userId', value: userId);
      await storage.write(key: 'refreshToken', value: refreshToken);
      await storage.write(key: 'accessToken', value: accessToken);
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
      print(userId);
      print(refreshToken);
      print(accessToken);

      return {
        'userId': userId,
        'refreshToken': refreshToken,
        'accessToken': accessToken,
      };
    } catch (e) {
      print('Failed to retrieve user data: $e');
      return {};
    }
  }
}
