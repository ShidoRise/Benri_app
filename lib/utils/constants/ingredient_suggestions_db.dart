import 'dart:convert';
import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class IngredientSuggestionsDB {
  List<IngredientSuggestion> ingredientSuggestions = [];
  final _ingredientSuggestionsBox = Hive.box('ingredientSuggestionsBox');

  Future<void> createInitialData() async {
    await fetchIngredientsFromApi();
    _updateLocalStorage();
  }

  void loadData() {
    final loadedData = _ingredientSuggestionsBox.get('INGREDIENTSLIST');
    if (loadedData != null) {
      ingredientSuggestions = List<IngredientSuggestion>.from(
        (loadedData as List).map(
          (ingredient) => IngredientSuggestion(
            name: ingredient.name,
            thumbnailUrl: ingredient.thumbnailUrl,
            nameInVietnamese: ingredient.nameInVietnamese,
          ),
        ),
      );
    }
  }

  Future<void> fetchIngredientsFromApi() async {
    final response =
        await http.get(Uri.parse('http://54.251.104.133/v1/api/ingredients'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['metadata'];
      for (Map<String, dynamic> element in data) {
        ingredientSuggestions.add(
          IngredientSuggestion(
              name: element['ingredient_name'],
              thumbnailUrl: element['ingredient_thumbnail'],
              nameInVietnamese: element['ingredient_name_vi']),
        );
      }
      _updateLocalStorage();
    } else {
      throw Exception('Failed to load ingredients from API');
    }
  }

  void _updateLocalStorage() {
    _ingredientSuggestionsBox.put('INGREDIENTSLIST', ingredientSuggestions);
    loadData();
  }
}
