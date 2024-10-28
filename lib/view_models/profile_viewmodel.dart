import 'package:benri_app/views/screens/login_screen.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  bool _notificationEnabled = true;
  bool _darkModeEnabled = false;

  bool get notificationEnabled => _notificationEnabled;
  bool get darkModeEnabled => _darkModeEnabled;

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
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void logout() {}
  void profileInformation() {
    // TODO: Implement profile information
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
