import 'dart:convert';
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
  static final _favoriteBox = Hive.box<bool>('favoriteBox');
  static Map<String, Recipes> recipes = {};
  static Set<String> favoriteRecipes = {};

  RecipesService._();

  static Future<void> initializeLocalData() async {
    await _loadDatabase();
    await _loadFavorites();
  }

  static Future<void> _loadDatabase() async {
    recipes.clear();
    for (var key in _recipeBox.keys) {
      final recipe = _recipeBox.get(key);
      if (recipe != null) {
        recipes[recipe.name] = recipe;
      }
    }
  }

  static Future<void> _loadFavorites() async {
    favoriteRecipes.clear();
    final favorites = _favoriteBox.keys;
    for (var key in favorites) {
      if (_favoriteBox.get(key) == true) {
        favoriteRecipes.add(key.toString());
      }
    }
  }

  static Future<void> toggleFavorite(Recipes recipe) async {
    final isFavorite = favoriteRecipes.contains(recipe.name);
    if (isFavorite) {
      favoriteRecipes.remove(recipe.name);
      await _favoriteBox.delete(recipe.name);
    } else {
      favoriteRecipes.add(recipe.name);
      await _favoriteBox.put(recipe.name, true);
    }
    await _updateLocalDatabase();
  }

  static bool isFavorite(Recipes recipe) {
    return favoriteRecipes.contains(recipe.name);
  }

  static Future<void> _updateLocalDatabase() async {
    await _recipeBox.clear();
    await _recipeBox.putAll(recipes);
  }

  static Future<List<Recipes>> getAllRecipes() async {
    return recipes.values.toList();
  }

  static Future<void> addRecipe(Recipes recipe) async {
    // Add to local storage
    recipes[recipe.name] = recipe;
    await _updateLocalDatabase();

    // Add to remote API
    // try {
    //   final userInfo = await UserLocal.getUserInfo();
    //   final response = await http.post(
    //     Uri.parse('$baseUrl/recipe'),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'x-api-key': Constants.apiKey,
    //       'x-rtoken-id': userInfo['token'] ?? '',
    //     },
    //     body: jsonEncode(recipe.toJson()),
    //   );

    //   if (response.statusCode != 200) {
    //     throw Exception('Failed to add recipe: ${response.body}');
    //   }
    // } catch (e) {
    //   print('Error adding recipe to remote: $e');
    // }
  }

  static Future<void> removeRecipe(Recipes recipe) async {
    recipes.remove(recipe.name);
    await _updateLocalDatabase();
  }

  static Future<void> updateRecipe(Recipes recipe) async {
    if (recipes.containsKey(recipe.name)) {
      recipes[recipe.name] = recipe;
      await _updateLocalDatabase();
    }

    // try {
    //   final userInfo = await UserLocal.getUserInfo();
    //   final response = await http.delete(
    //     Uri.parse('$baseUrl/recipe/${recipe.name}'),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'x-api-key': Constants.apiKey,
    //       'x-rtoken-id': userInfo['token'] ?? '',
    //     },
    //   );

    //   if (response.statusCode != 200) {
    //     throw Exception('Failed to delete recipe: ${response.body}');
    //   }
    // } catch (e) {
    //   print('Error removing recipe from remote: $e');
    // }
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

  static bool isFavourite(Recipes recipe) {
    return recipes.containsKey(recipe.name);
  }

  static Future<void> syncWithRemote() async {
    try {
      final userInfo = await UserLocal.getUserInfo();
      final response = await http.get(
        Uri.parse('$baseUrl/recipes'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': Constants.apiKey,
          'x-rtoken-id': userInfo['token'] ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        recipes.clear();
        for (var item in data) {
          final recipe = Recipes.fromJson(item);
          recipes[recipe.name] = recipe;
        }
        await _updateLocalDatabase();
      }
    } catch (e) {
      print('Error syncing with remote: $e');
    }
  }
}
