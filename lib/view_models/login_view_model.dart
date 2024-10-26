import 'package:benri_app/utils/constants/constant.dart';
import 'package:benri_app/views/screens/forgot_password.dart';
import 'package:benri_app/views/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void routeToSignUp(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUp()));
  }

  void routeToForgotPassword(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ForgotPassword()));
  }

  Future<bool> login() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('http://home.benriapp.com/v1/api/login'),
        headers: {
          'x-api-key': Constants.apiKey,
          'content-type': 'application/json'
        },
        body: jsonEncode({
          "email": emailController.text,
          "password": passwordController.text,
        }),
      );
      debugPrint("11qqq1");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['metadata'];
        final user = responseData['user'];
        final tokens = responseData['tokens'];
        final userId = user['_id'];
        final email = user['email'];

        await _saveUserData(
            userId, tokens['refreshToken'], tokens['accessToken']);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Login failed. Please try again.';
        debugPrint(response.body);
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again later.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _saveUserData(
      String userId, String refreshToken, String accessToken) async {
    try {
      await storage.write(key: 'userId', value: userId);
      await storage.write(key: 'refreshToken', value: refreshToken);
      await storage.write(key: 'accessToken', value: accessToken);
    } catch (e) {
      print('save data user into storage failed');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
