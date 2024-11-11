import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/models/ingredients/basket_ingredients.dart';
import 'package:benri_app/services/baskets_service.dart';
import 'package:benri_app/utils/constants/ingredient_suggestions_db.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class BasketViewModel extends ChangeNotifier {
  final _ingredientSuggestionsBox = Hive.box('ingredientSuggestionsBox');

  IngredientSuggestionsDB ingredientsDB = IngredientSuggestionsDB();

  List<IngredientSuggestion> filteredIngredientSuggestions = [];

  final DateFormat _dateFormat = DateFormat('yMd');
  DateTime _focusDate = DateTime.now();

  BasketViewModel() {
    _initializeData();
  }

  String get focusDateFormatted => _dateFormat.format(_focusDate);
  DateTime get focusDate => _focusDate;

  String? _selectedUnit;

  String? get selectedUnit => _selectedUnit;

  void updateSelectedUnit(String? unit) {
    _selectedUnit = unit;
    notifyListeners();
  }

  void _initializeData() {
    BasketService.initializeLocalData();
    // Initialize ingredient suggestions
    if (_ingredientSuggestionsBox.get('isFirstTime') == null) {
      ingredientsDB.createInitialData();
      _ingredientSuggestionsBox.put('isFirstTime', false);
      notifyListeners();
    } else {
      ingredientsDB.loadData();
    }
    notifyListeners();
  }

  void updateFocusDate(DateTime date) {
    _focusDate = date;
    BasketService.initializeBasketsForDate(focusDateFormatted);
    notifyListeners();
  }

  void addIngredient(BasketIngredient ingredient) {
    BasketService.addIngredient(focusDateFormatted, ingredient);
    notifyListeners();
  }

  void toggleIngredientSelection(int index) {
    BasketService.toggleIngredientSelection(focusDateFormatted, index);
    notifyListeners();
  }

  void deleteBasketItem(int index) {
    BasketService.deleteBasketItem(focusDateFormatted, index);
    notifyListeners();
  }

  void editBasketItem(BuildContext context, int index) {
    BasketService.editBasketItem(context, focusDateFormatted, index);
    notifyListeners();
  }

  void updateCalendarFocusDate(DateTime date, DateTime focusDate) {
    _focusDate = date;
    notifyListeners();
  }

  String formatDateTimeToString(DateTime date) {
    return _dateFormat.format(date);
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

  void clearIngredientSuggestions() {
    filteredIngredientSuggestions = [];
    notifyListeners();
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

  bool checkBasketIngredientsEmpty(String date) {
    return BasketService.baskets.containsKey(date) &&
        BasketService.baskets[date]!.basketIngredients.isNotEmpty;
  }
}
