import 'package:flutter/material.dart';

class FridgeScreenProvider with ChangeNotifier {
  late TabController tabController;
  TextEditingController searchController = TextEditingController();

  // Initialize the tab controller
  void initialize(BuildContext context) {
    tabController = TabController(length: 2, vsync: Navigator.of(context));
    notifyListeners();
  }

  // Dispose the controllers
  void disposeControllers() {
    tabController.dispose();
    notifyListeners();
  }

  // Notify listeners if something changes
  void notify() {
    notifyListeners();
  }
}
