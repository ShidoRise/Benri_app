import 'package:benri_app/services/fridge_drawers_serivce.dart';
import 'package:flutter/material.dart';

class DrawerProvider with ChangeNotifier {
  DrawerProvider() {
    initializeData();
  }

  Future<void> initializeData() async {
    await FridgeDrawersService.initializeLocalData();
    notifyListeners();
  }

  List<String> get drawers {
    final drawerNames = FridgeDrawersService.drawers.keys.toList();
    return drawerNames.isNotEmpty ? drawerNames : ['Refrigerator', 'Freezer'];
  }

  void addDrawer(String drawerName) async {
    await FridgeDrawersService.initializeDrawer(drawerName);
    notifyListeners();
  }

  void removeDrawer(int index) async {
    final drawerName = drawers[index];
    await FridgeDrawersService.removeDrawer(drawerName);
    notifyListeners();
  }
}
