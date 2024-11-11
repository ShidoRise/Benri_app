import 'package:flutter/material.dart';
import 'package:benri_app/models/ingredients/fridge_ingredients.dart';

class RecipeCreationProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeCookingController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();

  List<FridgeIngredient> ingredients = [];

  void addIngredient(FridgeIngredient ingredient) {
    ingredients.add(ingredient);
    notifyListeners();
  }

  void removeIngredient(int index) {
    ingredients.removeAt(index);
    notifyListeners();
  }

  void clearData() {
    nameController.clear();
    descriptionController.clear();
    timeCookingController.clear();
    ratingController.clear();
    ingredients.clear();
    notifyListeners();
  }
}
