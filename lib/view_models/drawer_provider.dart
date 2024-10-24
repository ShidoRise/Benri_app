import 'package:flutter/material.dart';

class DrawerProvider with ChangeNotifier {
  final List<String> _drawers = ['Refrigerator', 'Freezer'];

  List<String> get drawers => _drawers;

  void addDrawer(String drawerName) {
    _drawers.add(drawerName);
    notifyListeners();
  }

  void removeDrawer(int index) {
    _drawers.removeAt(index);
    notifyListeners();
  }
}
