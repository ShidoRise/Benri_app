import 'package:benri_app/services/auth_service.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:benri_app/view_models/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpViewModel extends ChangeNotifier {
  final String _errorMessage = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;
  Future<bool> verifyOTP(BuildContext context, String otp, String email,
      String password, String name) async {
    _isLoading = true;
    notifyListeners();
    if (await AuthService.verifyOTP(email, password, name, otp)) {
      if (context.mounted) {
        final profileViewModel = Provider.of<ProfileViewModel>(
          context,
          listen: false,
        );
        final basketViewModel = Provider.of<BasketViewModel>(
          context,
          listen: false,
        );

        await profileViewModel.checkLoginStatus();
        if (profileViewModel.isLoggedIn) {
          await basketViewModel.checkIsLoggedIn();
          await basketViewModel.initializeFamilyStatus();
        }
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
