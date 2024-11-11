import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DrawerProvider with ChangeNotifier {
  final List<String> _drawers = [];
  final _drawerBox = Hive.box('drawerBox'); // Hive box for drawers

  DrawerProvider() {
    loadDrawers();
  }

  List<String> get drawers => _drawers;

  // Load drawers from Hive when initializing
  void loadDrawers() {
    final loadedDrawers = _drawerBox
        .get('DRAWER_LIST', defaultValue: ['Refrigerator', 'Freezer']);
    _drawers.addAll(List<String>.from(loadedDrawers));
  }

  // Add a drawer and save it to Hive
  void addDrawer(String drawerName) {
    _drawers.add(drawerName);
    _updateLocalDatabase(); // Update Hive database
    notifyListeners();
  }

  // Remove a drawer by index and update Hive
  void removeDrawer(int index) {
    _drawers.removeAt(index);
    _updateLocalDatabase(); // Update Hive database
    notifyListeners();
  }

  // Private method to update Hive database with the current drawer list
  void _updateLocalDatabase() {
    _drawerBox.put('DRAWER_LIST', _drawers);
  }
}
