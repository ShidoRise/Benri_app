// ingredient_provider.dart
import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/services/fridge_drawers_serivce.dart';
import 'package:benri_app/utils/constants/ingredient_suggestions_db.dart';
import 'package:benri_app/views/widgets/bottom_sheet_add_ingredient.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/ingredients/fridge_ingredients.dart';

class IngredientProvider with ChangeNotifier {
  final _ingredientSuggestionsBox = Hive.box('ingredientSuggestionsBox');
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
  }

  IngredientProvider() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (_ingredientSuggestionsBox.get('isFirstTime') == null) {
      ingredientsDB.createInitialData();
      await _ingredientSuggestionsBox.put('isFirstTime', false);
    } else {
      ingredientsDB.loadData();
    }
    await FridgeDrawersService.initializeLocalData();
    notifyListeners();
  }

  List<FridgeIngredient> getIngredientsForDrawer(String drawerName) {
    return FridgeDrawersService.getIngredientsForDrawer(drawerName);
  }

  Future<void> addIngredient(
      String drawerName, FridgeIngredient ingredient) async {
    await FridgeDrawersService.addIngredient(drawerName, ingredient);
    notifyListeners();
  }

  Future<void> removeIngredient(String drawerName, int index) async {
    await FridgeDrawersService.removeIngredient(drawerName, index);
    notifyListeners();
  }

  Future<void> updateIngredient(
      String drawerName, FridgeIngredient ingredient, int index) async {
    await FridgeDrawersService.updateIngredient(drawerName, ingredient, index);
    notifyListeners();
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

  List<Map<String, dynamic>> getAllIngredientsWithDrawer() {
    return FridgeDrawersService.getAllIngredientsWithDrawer();
  }

  Future<void> editIngredient(
      BuildContext context, String drawerName, int index) async {
    final currentIngredient =
        FridgeDrawersService.getIngredientsForDrawer(drawerName)[index];
    final updatedIngredient = await addFridgeIngredientDialog(
      context,
      fridgeIngredient: currentIngredient,
    );

    if (updatedIngredient != null) {
      await updateIngredient(drawerName, updatedIngredient, index);
    }
  }

  String getImageUrlFromLocalStorage(String ingredientName) {
    if (ingredientName.isNotEmpty) {
      final ingredient = ingredientsDB.ingredientSuggestions.firstWhere(
        (i) => i.name.toLowerCase() == ingredientName.toLowerCase(),
        orElse: () => IngredientSuggestion(
            name: '', thumbnailUrl: '', nameInVietnamese: ''),
      );
      return ingredient.thumbnailUrl;
    }
    return '';
  }
}
