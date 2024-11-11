import 'package:benri_app/utils/constants/constant.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpViewModel extends ChangeNotifier {
  // final storage = FlutterSecureStorage();
  final String _errorMessage = '';
  bool _isLoading = false;
  String get errorMessage => _errorMessage;
  Future<bool> verifyOTP(
      String otp, String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/verify_otp_and_signup'),
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
      _isLoading = false;
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['metadata'];
        final user = responseData['user'];
        final tokens = responseData['tokens'];
        print('Verifying OTP: $otp');
        await _saveUserData(
            user['_id'], tokens['refreshToken'], tokens['accessToken']);
        notifyListeners();
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
      // await storage.write(key: 'userId', value: userId);
      // await storage.write(key: 'refreshToken', value: refreshToken);
      // await storage.write(key: 'accessToken', value: accessToken);
    } catch (e) {
      print('save data user into storage failed');
    }
  }
}
