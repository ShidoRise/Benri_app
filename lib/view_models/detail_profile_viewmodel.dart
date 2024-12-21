import 'package:benri_app/services/user_local.dart';
import 'package:flutter/material.dart';

class DetailProfileViewModel extends ChangeNotifier {
  Map<String, String> userInfo = {};
  DetailProfileViewModel() {
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    userInfo = await UserLocal.getUserInfo();

    notifyListeners();
  }
}
