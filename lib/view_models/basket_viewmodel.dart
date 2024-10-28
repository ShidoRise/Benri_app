import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/models/ingredients/ingredients.dart';
import 'package:benri_app/utils/constants/ingredient_suggestions_db.dart';
import 'package:benri_app/utils/constants/local_db.dart';
import 'package:benri_app/views/widgets/add_ingredient_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class BasketViewModel extends ChangeNotifier {
  final _basketBox = Hive.box('basketBox');
  final _ingredientSuggestionsBox = Hive.box('ingredientSuggestionsBox');

  BasketsLocalDB db = BasketsLocalDB();
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
    if (_basketBox.get('isFirstTime') == null) {
      db.createInitialData();
      db.updateDatabase();
      _basketBox.put('isFirstTime', false);
      notifyListeners();
    } else {
      db.loadData();
    }

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
    _initializeBasketsForDate(_focusDate);
    notifyListeners();
  }

  void _initializeBasketsForDate(DateTime date) {
    String formattedDate = _dateFormat.format(date);
    if (!db.baskets.containsKey(formattedDate)) {
      db.baskets[formattedDate] = [];
    }
  }

  void addIngredient(Ingredient ingredient) {
    _initializeBasketsForDate(_focusDate);
    db.baskets[focusDateFormatted]!.add(ingredient);
    db.updateDatabase();
    notifyListeners();
  }

  void toggleIngredientSelection(int index) {
    if (index >= 0 && index < db.baskets[focusDateFormatted]!.length) {
      db.baskets[focusDateFormatted]![index].isSelected =
          !db.baskets[focusDateFormatted]![index].isSelected;
      db.updateDatabase();
      notifyListeners();
    }
  }

  void deleteBasketItem(int index) {
    if (index >= 0 && index < db.baskets[focusDateFormatted]!.length) {
      db.baskets[focusDateFormatted]!.removeAt(index);
      db.updateDatabase();
      notifyListeners();
    }
  }

  void editBasketItem(BuildContext context, int index) async {
    if (index >= 0 && index < db.baskets[focusDateFormatted]!.length) {
      Ingredient currentIngredient = db.baskets[focusDateFormatted]![index];

      Ingredient? updatedIngredient =
          await addIngredientDialog(context, ingredient: currentIngredient);

      if (updatedIngredient != null) {
        db.baskets[focusDateFormatted]![index] = updatedIngredient;
        db.updateDatabase();
        notifyListeners();
      }
    }
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
}
