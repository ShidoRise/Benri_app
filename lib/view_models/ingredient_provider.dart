import 'package:flutter/material.dart';
import '../models/ingredients/fridge_ingredients.dart';

class IngredientProvider with ChangeNotifier {
  // Use a map to track ingredients per drawer
  final Map<String, List<FridgeIngredients>> _drawerIngredients = {};

  // Getter to get the list of ingredients for a specific drawer
  List<FridgeIngredients> getIngredientsForDrawer(String drawerName) {
    return _drawerIngredients[drawerName] ?? [];
  }

  // Add an ingredient to a specific drawer
  void addIngredient(String drawerName, FridgeIngredients ingredient) {
    if (_drawerIngredients.containsKey(drawerName)) {
      _drawerIngredients[drawerName]!.add(ingredient);
    } else {
      _drawerIngredients[drawerName] = [ingredient];
    }
    notifyListeners();
  }

  // Remove an ingredient from a specific drawer
  void removeIngredient(String drawerName, int index) {
    if (_drawerIngredients.containsKey(drawerName)) {
      _drawerIngredients[drawerName]!.removeAt(index);
      notifyListeners();
    }
  }

  // Method to get all ingredients along with their drawer name
  List<Map<String, dynamic>> getAllIngredientsWithDrawer() {
    List<Map<String, dynamic>> allIngredients = [];
    _drawerIngredients.forEach((drawerName, ingredients) {
      for (var ingredient in ingredients) {
        allIngredients.add({
          'drawerName': drawerName, // Store the drawer name with the ingredient
          'ingredient': ingredient,
        });
      }
    });
    return allIngredients;
  }
}
