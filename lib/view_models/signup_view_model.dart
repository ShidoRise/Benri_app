import 'package:benri_app/services/auth_service.dart';
import 'package:benri_app/utils/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final AuthService authService = AuthService();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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

  Future<bool> signUp() async {
    print('111');
    if (true) {
      try {
        _isLoading = true;
        notifyListeners();
        if (await authService.preSignUp(
          emailController.text.trim(),
          passwordController.text.trim(),
          nameController.text.trim(),
        )) {
          _isLoading = false;
          return true;
        } else {
          return false;
        }
      } catch (e) {
        _errorMessage = e.toString();
        notifyListeners();
        return false;
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
