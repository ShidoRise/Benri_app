import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';

class IngredientSuggestionsService {
  IngredientSuggestionsService._();

  static List<IngredientSuggestion> ingredientSuggestions = [];
  static final _ingredientSuggestionsBox =
      Hive.box<IngredientSuggestion>('ingredientSuggestionsBox');

  static Future<void> initializeLocalData() async {
    try {
      if (_ingredientSuggestionsBox.isEmpty) {
        await _loadIngredientsFromJson();
      } else {
        ingredientSuggestions = _ingredientSuggestionsBox.values.toList();
        print(
            "Ingredient suggestions initialized from Hive ${ingredientSuggestions.length}");
      }
    } catch (e) {
      print('Error initializing ingredient suggestions: $e');
    }
  }

  static Future<void> _loadIngredientsFromJson() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/ingredientSuggestions.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      ingredientSuggestions = jsonData
          .map((data) => IngredientSuggestion(
                name: data['ingredient_name'] ?? '',
                thumbnailUrl: data['ingredient_thumbnail'] ?? '',
                nameInVietnamese: data['ingredient_name_vi'] ?? '',
              ))
          .toList();

      print(
          "Ingredient suggestions initialized from Hive ${ingredientSuggestions.length}");
      await _ingredientSuggestionsBox.clear();
      await _ingredientSuggestionsBox.addAll(ingredientSuggestions);
    } catch (e) {
      print('Error loading ingredients from JSON: $e');
    }
  }

  static List<IngredientSuggestion> filterSuggestions(String query) {
    if (query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();
    return ingredientSuggestions.where((ingredient) {
      final lowercaseName = ingredient.name.toLowerCase();
      final lowercaseViName = ingredient.nameInVietnamese.toLowerCase();
      return lowercaseName.contains(lowercaseQuery) ||
          lowercaseViName.contains(lowercaseQuery);
    }).toList();
  }

  static Future<void> refreshIngredients() async {
    await _loadIngredientsFromJson();
  }
}
