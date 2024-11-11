import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/utils/constants/fridge_ingredient_local_db.dart';
import 'package:benri_app/utils/constants/ingredient_suggestions_db.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/ingredients/fridge_ingredients.dart';
import '../views/widgets/bottom_sheet_add_ingredient.dart';

class IngredientProvider with ChangeNotifier {
  final _fridgeIngredientBox = Hive.box('fridgeIngredientBox');
  final _ingredientSuggestionsBox = Hive.box('ingredientSuggestionsBox');

  FridgeIngredientLocalDb db = FridgeIngredientLocalDb();
  IngredientSuggestionsDB ingredientsDB = IngredientSuggestionsDB();

  List<IngredientSuggestion> filteredIngredientSuggestions = [];

  DateTime? _expirationDate;
  DateTime? get expirationDate => _expirationDate;

  void setExpirationDate(DateTime date) {
    _expirationDate = date;
    notifyListeners();
  }

  void initializeExpirationDate(DateTime? date) {
    _expirationDate = date;
    notifyListeners();
  }

  void clearExpirationDate() {
    _expirationDate = null;
    notifyListeners();
  }

  void setExpirationDays(int days) {
    final DateTime newDate = DateTime.now().add(Duration(days: days));
    setExpirationDate(newDate);
    notifyListeners();
  }

  IngredientProvider() {
    _initializeData();
  }

  void _initializeData() {
    if (_fridgeIngredientBox.get('isFirstTime') == null) {
      db.createInitialData();
      db.updateDatabase();
      _fridgeIngredientBox.put('isFirstTime', false);
    } else {
      db.loadData();
    }

    if (_ingredientSuggestionsBox.get('isFirstTime') == null) {
      ingredientsDB.createInitialData();
      _ingredientSuggestionsBox.put('isFirstTime', false);
    } else {
      ingredientsDB.loadData();
    }

    notifyListeners();
  }

  void _initializeDrawer(String drawerName) {
    if (!db.fridgeIngredients.containsKey(drawerName)) {
      db.fridgeIngredients[drawerName] = [];
    }
  }

  List<FridgeIngredient> getIngredientsForDrawer(String drawerName) {
    return db.fridgeIngredients[drawerName] ?? [];
  }

  void addIngredient(String drawerName, FridgeIngredient ingredient) {
    _initializeDrawer(drawerName);
    db.fridgeIngredients[drawerName]!.add(ingredient);
    db.updateDatabase();
    notifyListeners();
  }

  void removeIngredient(String drawerName, int index) {
    if (db.fridgeIngredients.containsKey(drawerName)) {
      db.fridgeIngredients[drawerName]!.removeAt(index);
      db.updateDatabase();
      notifyListeners();
    }
  }

  void updateIngredient(String drawerName, FridgeIngredient updatedIngredient) {
    if (db.fridgeIngredients.containsKey(drawerName)) {
      // Find the index of the ingredient to update by matching the name
      final ingredientList = db.fridgeIngredients[drawerName]!;
      final index = ingredientList.indexWhere(
          (ingredient) => ingredient.name == updatedIngredient.name);

      if (index != -1) {
        ingredientList[index] =
            updatedIngredient; // Replace the old ingredient with the updated one
        notifyListeners();
      }
    }
  }

  void editIngredient(
      BuildContext context, String drawerName, int index) async {
    if (index >= 0 && index < db.fridgeIngredients[drawerName]!.length) {
      FridgeIngredient currentIngredient =
          db.fridgeIngredients[drawerName]![index];
      FridgeIngredient? updatedIngredient = await addFridgeIngredientDialog(
          context,
          fridgeIngredient: currentIngredient);
      if (updatedIngredient != null) {
        db.fridgeIngredients[drawerName]![index] = updatedIngredient;
        db.updateDatabase();
        notifyListeners();
      }
    }
  }

  void filterIngredientSuggestions(String query) {
    if (query.isNotEmpty) {
      filteredIngredientSuggestions = ingredientsDB.ingredientSuggestions
          .where((ingredient) =>
              ingredient.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      filteredIngredientSuggestions = [];
    }
    notifyListeners();
  }

  String getImageUrlFromLocalStorage(String ingredientName) {
    final suggestion = ingredientsDB.ingredientSuggestions.firstWhere(
      (ingredient) =>
          ingredient.name.toLowerCase() == ingredientName.toLowerCase(),
      orElse: () => IngredientSuggestion(
          name: '', thumbnailUrl: '', nameInVietnamese: ''),
    );
    return suggestion.thumbnailUrl;
  }

  // Method to get all ingredients along with their drawer name
  List<Map<String, dynamic>> getAllIngredientsWithDrawer() {
    List<Map<String, dynamic>> allIngredients = [];
    db.fridgeIngredients.forEach((drawerName, ingredients) {
      for (var ingredient in ingredients) {
        allIngredients.add({
          'drawerName': drawerName,
          'ingredient': ingredient,
        });
      }
    });
    return allIngredients;
  }
}
