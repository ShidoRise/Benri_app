import 'package:benri_app/utils/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  SignUpViewModel() {
    emailController.addListener(updateCanSignUp);
    passwordController.addListener(updateCanSignUp);
    nameController.addListener(updateCanSignUp);
    confirmPasswordController.addListener(updateCanSignUp);
  }

  bool _isLoading = false;
  String _errorMessage = 'Check your inputs';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  bool _canSignUp = false;
  bool get canSignUp => _canSignUp;

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  void updateCanSignUp() {
    bool isValid = true;
    print('1111');

    if (emailController.text.isEmpty || !_isValidEmail(emailController.text)) {
      _errorMessage = 'Invalid email address';
      isValid = false;
    } else if (nameController.text.isEmpty) {
      _errorMessage = 'Name is required';
      isValid = false;
    } else if (!_isValidPassword(passwordController.text)) {
      _errorMessage = 'Password must be at least 6 characters long';
      isValid = false;
    } else if (passwordController.text != confirmPasswordController.text) {
      _errorMessage = 'Passwords do not match';
      isValid = false;
    }

    if (_canSignUp != isValid) {
      _canSignUp = isValid;
      notifyListeners();
    }
  }

  Future<bool> signUp() async {
    if (!_canSignUp) {
      return false;
    }
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/pre_signup'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': Constants.apiKey,
        },
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "name": nameController.text.trim(),
        }),
      );
      _isLoading = false;
      debugPrint(response.body);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    emailController.removeListener(updateCanSignUp);
    passwordController.removeListener(updateCanSignUp);
    nameController.removeListener(updateCanSignUp);
    confirmPasswordController.removeListener(updateCanSignUp);
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
