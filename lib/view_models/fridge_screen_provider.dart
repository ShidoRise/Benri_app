import 'package:flutter/material.dart';

class FridgeScreenProvider with ChangeNotifier {
  int _currentTabIndex = 0;
  TextEditingController searchController = TextEditingController();

  int get currentTabIndex => _currentTabIndex;

  void changeTab(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
