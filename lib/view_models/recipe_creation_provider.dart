import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/services/ingredient_suggestions_service.dart';
import 'package:flutter/material.dart';
import 'package:benri_app/models/ingredients/fridge_ingredients.dart';

class RecipeCreationProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeCookingController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();

  List<FridgeIngredient> ingredients = [];

  List<IngredientSuggestion> filteredIngredientSuggestions = [];

  final List<String> _unitOptions = ['gam', 'kg', 'hộp', 'quả', 'lít'];
  List<String> get unitOptions => _unitOptions;

  String? _selectedUnit;
  String? get selectedUnit => _selectedUnit;

  void updateSelectedUnit(String? unit) {
    _selectedUnit = unit;
    notifyListeners();
  }

  void resetSelections() {
    _selectedUnit = null;
    notifyListeners();
  }

  void addIngredient(FridgeIngredient ingredient) {
    ingredients.add(ingredient);
    notifyListeners();
  }

  void removeIngredient(int index) {
    ingredients.removeAt(index);
    notifyListeners();
  }

  void filterIngredientSuggestions(String query) {
    if (query.isNotEmpty) {
      filteredIngredientSuggestions = IngredientSuggestionsService
          .ingredientSuggestions
          .where((ingredient) =>
              ingredient.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      filteredIngredientSuggestions = [];
    }
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
