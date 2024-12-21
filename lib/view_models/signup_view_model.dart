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
  String _errorMessage = 'Kiểm tra lại thông tin';

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

  String? validateInputs() {
    if (nameController.text.trim().isEmpty) {
      return 'Vui lòng nhập tên';
    }

    if (!_isValidEmail(emailController.text.trim())) {
      return 'Email không hợp lệ';
    }

    if (!_isValidPassword(passwordController.text)) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    if (passwordController.text != confirmPasswordController.text) {
      return 'Mật khẩu xác nhận không khớp';
    }

    return null;
  }

  Future<bool> signUp() async {
    final validationError = validateInputs();
    if (validationError != null) {
      _errorMessage = validationError;
      notifyListeners();
      return false;
    }

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
        _errorMessage = 'Đăng ký thất bại';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
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
