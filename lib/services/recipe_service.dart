import 'dart:convert';

import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/services/user_local.dart';
import 'package:benri_app/utils/constants/fridge_ingredient_local_db.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../utils/constants/constant.dart';

class RecipeService {
  final String baseUrl = dotenv.get('API_URL');
  static const String _boxName = 'recipeBox';
  final Box<Recipes> box = Hive.box<Recipes>(_boxName);
  final FridgeIngredientLocalDb _fridgeDBb = FridgeIngredientLocalDb();

  Future<Box<Recipes>> _openBox() async {
    return await Hive.openBox<Recipes>(_boxName);
  }

  Future<List<Recipes>> getAllRecipes() async {
    return box.values.toList();
  }

  Future<void> addRecipe(Recipes recipe) async {
    Map<String, dynamic> data = recipe.toJson();
    print(data['name']);
    print(data);
    final UserLocal userLocal = UserLocal();
    final Future<Map<String, String>> userInfo = UserLocal.getUserInfo();
    print(userInfo.toString());
    final response = await http.post(
      Uri.parse('$baseUrl/recipe'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': Constants.apiKey,
        'x-rtoken-id': ''
      },
      body: jsonEncode({}),
    );
    box.add(recipe);
  }

  Future<void> removeRecipe(Recipes recipe) async {
    box.delete(recipe);
  }

  Future<void> updateRecipe(Recipes recipe) async {
    await box.put(recipe.key, recipe);
  }

  List<Map<String, dynamic>> checkIngredientsAvailable(
      List<FridgeIngredient> recipeIngredients) {
    _fridgeDBb.loadData();
    Map<String, List<FridgeIngredient>> fridgeItems =
        _fridgeDBb.fridgeIngredients;

    List<Map<String, dynamic>> availabilityStatus = [];
    for (var recipeIngredient in recipeIngredients) {
      String? drawerName;

      fridgeItems.forEach((drawer, ingredients) {
        if (ingredients.any((fridgeItem) =>
            fridgeItem.name.toLowerCase() ==
            recipeIngredient.name.toLowerCase())) {
          drawerName = drawer;
        }
      });

      availabilityStatus.add({
        'ingredient': recipeIngredient,
        'isAvailable': drawerName != null,
        'drawerName': drawerName,
      });
    }
    return availabilityStatus;
  }
}
