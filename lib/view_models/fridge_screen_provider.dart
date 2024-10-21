import 'package:flutter/material.dart';

class FridgeScreenProvider with ChangeNotifier {
  late TabController tabController;
  TextEditingController searchController = TextEditingController();

  // Initialize the tab controller
  void initialize(TickerProvider vsync) {
    tabController = TabController(length: 2, vsync: vsync);
  }

  // Dispose the controllers
  void disposeControllers() {
    tabController.dispose();
    searchController.dispose();
  }

  // Notify listeners if something changes
  void notify() {
    notifyListeners();
  }
}
