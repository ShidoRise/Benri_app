// fridge_ingredients_service.dart
import 'package:benri_app/models/fridge_drawers/fridge_drawers.dart';
import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/views/widgets/add_drawer.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FridgeDrawersService {
  static Map<String, FridgeDrawer> drawers = {};
  static final _fridgeDrawerBox = Hive.box<FridgeDrawer>('fridgeDrawerBox');
  static const List<String> defaultDrawers = ['Ngăn đá', 'Ngăn ướp lạnh'];

  FridgeDrawersService._();

  static Future<void> initializeLocalData() async {
    await _loadDatabase();
    if (_fridgeDrawerBox.isEmpty) {
      for (String drawerName in defaultDrawers) {
        drawers[drawerName] = FridgeDrawer(
          name: drawerName,
          fridgeIngredients: [],
        );
      }
      await _updateLocalDatabase();
    }
  }

  static Future<void> _loadDatabase() async {
    for (var key in _fridgeDrawerBox.keys) {
      final drawer = _fridgeDrawerBox.get(key);
      if (drawer != null) {
        drawers[drawer.name] = drawer;
      }
    }
  }

  static Future<void> _updateLocalDatabase() async {
    await _fridgeDrawerBox.clear();
    await _fridgeDrawerBox.putAll(drawers);
  }

  static Future<void> initializeDrawer(String drawerName) async {
    if (!drawers.containsKey(drawerName)) {
      drawers[drawerName] = FridgeDrawer(
        name: drawerName,
        fridgeIngredients: [],
      );
      await _updateLocalDatabase();
    }
  }

  static List<FridgeIngredient> getIngredientsForDrawer(String drawerName) {
    return drawers[drawerName]?.fridgeIngredients ?? [];
  }

  static Future<void> addIngredient(
      String drawerName, FridgeIngredient ingredient) async {
    await initializeDrawer(drawerName);
    drawers[drawerName]!.fridgeIngredients.add(ingredient);
    await _updateLocalDatabase();
  }

  static Future<void> removeIngredient(String drawerName, int index) async {
    if (drawers.containsKey(drawerName)) {
      drawers[drawerName]!.fridgeIngredients.removeAt(index);
      await _updateLocalDatabase();
    }
  }

  static Future<void> updateIngredient(
      String drawerName, FridgeIngredient updatedIngredient, int index) async {
    if (drawers.containsKey(drawerName)) {
      drawers[drawerName]!.fridgeIngredients[index] = updatedIngredient;
      await _updateLocalDatabase();
    }
  }

  static List<Map<String, dynamic>> getAllIngredientsWithDrawer() {
    List<Map<String, dynamic>> allIngredients = [];
    drawers.forEach((drawerName, drawer) {
      for (var ingredient in drawer.fridgeIngredients) {
        allIngredients.add({
          'drawerName': drawerName,
          'ingredient': ingredient,
        });
      }
    });
    print('1=====');
    print(allIngredients.toString());
    return allIngredients;
  }

  static List<String> getAllDrawerNames() {
    return drawers.keys.toList();
  }

  static Future<List<String>> getAllIngredientNames() async {
    List<String> allIngredientNames = [];
    for (var drawer in _fridgeDrawerBox.values) {
      for (var ingredient in drawer.fridgeIngredients) {
        allIngredientNames.add(ingredient.name);
      }
    }
    print(allIngredientNames.toString());
    return allIngredientNames;
  }

  static Future<void> removeDrawer(String drawerName) async {
    drawers.remove(drawerName);
    await _updateLocalDatabase();
  }

  static Future<void> editDrawer(
      BuildContext context, String drawerName) async {
    final updateDrawerName = await showAddDrawerDialog(
        context, 'Sửa tên ngăn tủ',
        drawerName: drawerName);
    if (updateDrawerName != null) {
      initializeDrawer(updateDrawerName);
      drawers[updateDrawerName] = drawers[drawerName]!;
      drawers[updateDrawerName]!.name = updateDrawerName;
      drawers.remove(drawerName);
    }
    await _updateLocalDatabase();
  }
}
