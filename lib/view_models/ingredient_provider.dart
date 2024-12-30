// ingredient_provider.dart
import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/services/fridge_drawers_serivce.dart';
import 'package:benri_app/services/ingredient_suggestions_service.dart';
import 'package:benri_app/views/widgets/bottom_sheet_add_ingredient.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/ingredients/fridge_ingredients.dart';

enum SortMode { expirationDate, compartment, none }

class IngredientProvider with ChangeNotifier {
  List<IngredientSuggestion> filteredIngredientSuggestions = [];

  final List<String> _unitOptions = ['gam', 'kg', 'hộp', 'quả', 'lít'];
  List<String> get unitOptions => _unitOptions;

  String? _selectedUnit;
  String? get selectedUnit => _selectedUnit;

  SortMode _currentSortMode = SortMode.none;
  SortMode get currentSortMode => _currentSortMode;

  void setSortMode(SortMode mode) {
    _currentSortMode = mode;
    notifyListeners();
  }

  List<Map<String, dynamic>> getSortedIngredients() {
    final ingredients = getAllIngredientsWithDrawer();

    switch (_currentSortMode) {
      case SortMode.expirationDate:
        return List.from(ingredients)
          ..sort((a, b) {
            final aDate = (a['ingredient'] as FridgeIngredient).expirationDate;
            final bDate = (b['ingredient'] as FridgeIngredient).expirationDate;
            if (aDate == null && bDate == null) return 0;
            if (aDate == null) return 1;
            if (bDate == null) return -1;
            return aDate.compareTo(bDate);
          });
      case SortMode.compartment:
        return List.from(ingredients)
          ..sort((a, b) =>
              (a['drawerName'] as String).compareTo(b['drawerName'] as String));
      case SortMode.none:
        return ingredients;
    }
  }

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

  void updateSelectedUnit(String? unit) {
    _selectedUnit = unit;
    notifyListeners();
  }

  void resetSelections() {
    _selectedUnit = null;
    notifyListeners();
  }

  IngredientProvider() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    IngredientSuggestionsService.initializeLocalData();
    await FridgeDrawersService.initializeLocalData();
    notifyListeners();
  }

  List<FridgeIngredient> getIngredientsForDrawer(String drawerName) {
    return FridgeDrawersService.getIngredientsForDrawer(drawerName);
  }

  Future<void> addIngredient(
      String drawerName, FridgeIngredient ingredient) async {
    resetSelections();
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
      filteredIngredientSuggestions = IngredientSuggestionsService
          .ingredientSuggestions
          .where((ingredient) => ingredient.nameInVietnamese
              .toLowerCase()
              .contains(query.toLowerCase()))
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

    if (unitOptions.contains(currentIngredient.unit)) {
      updateSelectedUnit(currentIngredient.unit);
    }

    final updatedIngredient = await addFridgeIngredientDialog(
      context,
      fridgeIngredient: currentIngredient,
    );

    if (updatedIngredient != null) {
      await updateIngredient(drawerName, updatedIngredient, index);
    }

    resetSelections();
  }

  String getImageUrlFromLocalStorage(String ingredientName) {
    if (ingredientName.isNotEmpty) {
      final ingredient =
          IngredientSuggestionsService.ingredientSuggestions.firstWhere(
        (i) => i.nameInVietnamese.toLowerCase() == ingredientName.toLowerCase(),
        orElse: () => IngredientSuggestion(
            name: '', thumbnailUrl: '', nameInVietnamese: ''),
      );
      return ingredient.thumbnailUrl;
    }
    return '';
  }
}
