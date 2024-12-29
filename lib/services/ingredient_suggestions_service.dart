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

  static Future<void> addNewIngredientSuggestion(String name) async {
    try {
      final newSuggestion = IngredientSuggestion(
        name: name,
        thumbnailUrl: '',
        nameInVietnamese: name,
      );

      if (!ingredientSuggestions.any((s) =>
          s.name.toLowerCase() == name.toLowerCase() ||
          s.nameInVietnamese.toLowerCase() == name.toLowerCase())) {
        ingredientSuggestions.add(newSuggestion);
        await _ingredientSuggestionsBox.add(newSuggestion);
      }
    } catch (e) {
      print('Error adding new ingredient suggestion: $e');
    }
  }

  static Future<void> refreshIngredients() async {
    await _loadIngredientsFromJson();
  }
}
