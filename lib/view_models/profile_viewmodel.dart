import 'package:benri_app/services/auth_service.dart';
import 'package:benri_app/services/user_local.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:benri_app/views/screens/change_pasword_screen.dart';
import 'package:benri_app/views/screens/detail_profile_screen.dart';
import 'package:benri_app/views/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:benri_app/view_models/theme_provider.dart';

class ProfileViewModel extends ChangeNotifier {
  bool _notificationEnabled = true;
  bool _darkModeEnabled = false;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  Future<bool> isGG() async {
    final isGG = await AuthService.storage.read(key: 'isGG');
    if (isGG == 'true') {
      return true;
    }
    return false;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get notificationEnabled => _notificationEnabled;
  bool get darkModeEnabled =>
      Provider.of<ThemeProvider>(navigatorKey.currentContext!, listen: false)
          .isDarkMode;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Map<String, dynamic> userInfo = {};

  ProfileViewModel() {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      final Map<String, String> fetchedUserInfo = await UserLocal.getUserInfo();

      if (fetchedUserInfo.isNotEmpty &&
          fetchedUserInfo['userId']?.isNotEmpty == true) {
        _isLoggedIn = true;
        userInfo = fetchedUserInfo;
        print('Login successful - UserID: ${fetchedUserInfo['userId']}');
      } else {
        _isLoggedIn = false;
        userInfo = {};
        print('No valid user info found');
      }

      notifyListeners();
    } catch (e) {
      print('Error checking login status: $e');
      _isLoggedIn = false;
      userInfo = {};
      notifyListeners();
    }
  }

  void toggleNotification() {
    _notificationEnabled = !_notificationEnabled;
    notifyListeners();
  }

  void toggleDarkMode() {
    final themeProvider =
        Provider.of<ThemeProvider>(navigatorKey.currentContext!, listen: false);
    themeProvider.toggleTheme();
    notifyListeners();
  }

  void login(BuildContext context) {
    print('login');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> logout(BuildContext context) async {
    print('logouttttttt');
    try {
      _isLoading = true;
      notifyListeners();

      await UserLocal.logout();
      final isGG = await AuthService.storage.read(key: 'isGG');
      if (isGG == 'true') {
        await AuthService.signOut();
        AuthService.storage.delete(key: 'isGG');
      }
      await AuthService.signOut();
      _isLoggedIn = false;
      userInfo = {};

      final basketViewModel =
          Provider.of<BasketViewModel>(context, listen: false);
      await basketViewModel.checkIsLoggedIn();
      await basketViewModel.resetFamilyStatus();

      _isLoading = false;

      notifyListeners();

      if (context.mounted) {
        Fluttertoast.showToast(
          msg: "Đăng xuất thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[800],
          textColor: Colors.white,
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error during logout: $e');
    }
  }

  void profileInformation(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DetailProfileScreen()));
  }

  void changePassWord(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ChangePassWordScreen()));
  }

  void rateApp() {}
  void shareApp() {}
  void contact() {}
  void feedback() {}
}
