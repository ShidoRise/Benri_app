import 'dart:convert';
import 'dart:math';
import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/services/user_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../utils/constants/constant.dart';

class RecipesService {
  static final String baseUrl = dotenv.get('API_URL');
  static final _recipeBox = Hive.box<Recipes>('recipeBox');
  static List<Recipes> recipes = [];
  static List<Recipes> favoriteRecipes = [];

  RecipesService._();

  static Future<List<Recipes>> fetchDataFromDb() async {
    return await _loadDatabase();
  }

  static Future<List<String>> fetchCategories() async {
    try {
      final response = await await http.get(
        Uri.parse('$baseUrl/recipe/categories'),
        headers: {
          'x-api-key': Constants.apiKey,
          'content-type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        print('111');

        final List<dynamic> responseData =
            jsonDecode(response.body)['metadata'];
        List<String> categories = [];
        print('111a');
        for (var category in responseData) {
          categories.add(category);
        }
        print('===categories :: $categories');
        return categories;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<Recipes>> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/recipe/all'),
        headers: {
          'x-api-key': Constants.apiKey,
          'content-type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            jsonDecode(response.body)['metadata'];
        print('1111');
        recipes = responseData.map((json) => Recipes.fromJson(json)).toList();
        print('11');
        return recipes;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<Recipes>> _loadDatabase() async {
    favoriteRecipes.clear();
    for (var key in _recipeBox.keys) {
      final recipe = _recipeBox.get(key);
      if (recipe != null) {
        favoriteRecipes.add(recipe);
      }
    }
    print('===favoriteRecipes :: $favoriteRecipes');
    return favoriteRecipes;
  }

  static Future<void> toggleFavorite(Recipes recipe) async {
    if (recipe.isFavorite) {
      await _recipeBox.put(recipe.name, recipe);
    } else {
      await _recipeBox.delete(recipe.name);
    }
  }

  static Future<void> deleteFromFavourite(Recipes recipe) async {
    _recipeBox.delete(recipe.name);

    favoriteRecipes.clear();
    _loadDatabase();
  }

  static Future<List<Recipes>> getAllRecipes() async {
    return recipes;
  }

  static Future<List<Recipes>> getAllFavouriteRecipes() async {
    return await _loadDatabase();
  }

  static Future<void> removeRecipe(Recipes recipe) async {
    recipes.remove(recipe.name);
  }

  static List<Map<String, dynamic>> checkIngredientsAvailable(
      List<FridgeIngredient> recipeIngredients) {
    List<Map<String, dynamic>> availabilityStatus = [];
    for (var ingredient in recipeIngredients) {
      availabilityStatus.add({
        'ingredient': ingredient,
        'isAvailable': false,
        'drawerName': null,
      });
    }
    return availabilityStatus;
  }

  static Future<void> addRecipe(Recipes recipe) async {
    await _recipeBox.put(recipe.name, recipe);
  }
}
