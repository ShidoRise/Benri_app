import 'package:benri_app/services/user_local.dart';
import 'package:benri_app/views/screens/detail_profile_screen.dart';
import 'package:benri_app/views/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileViewModel extends ChangeNotifier {
  bool _notificationEnabled = true;
  bool _darkModeEnabled = false;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool get notificationEnabled => _notificationEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  ProfileViewModel() {
    checkLoginStatus();
  }
  Future<void> checkLoginStatus() async {
    final userInfo = await UserLocal.getUserInfo();
    _isLoggedIn = userInfo['userId']?.isNotEmpty == true;
    notifyListeners();
  }

  void toggleNotification() {
    _notificationEnabled = !_notificationEnabled;
    notifyListeners();
  }

  void toggleDarkMode() {
    _darkModeEnabled = !_darkModeEnabled;
    notifyListeners();
  }

  void login(BuildContext context) {
    // TODO: Implement login
    print('login');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void logout() {
    UserLocal.logout();
    _isLoggedIn = false;
    notifyListeners();
    Fluttertoast.showToast(
      msg: "Logged out successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
    );
  }

  void profileInformation(BuildContext context) {
    // TODO: Implement profile information
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DetailProfileScreen()));
  }

  void rateApp() {
    // TODO: Implement rate app
  }
  void shareApp() {
    // TODO: Implement share app
  }
  void contact() {
    // TODO: Implement contact
  }
  void feedback() {
    // TODO: Implement feedback
  }
}
