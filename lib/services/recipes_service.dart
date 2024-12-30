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
      ).timeout(Duration(seconds: 4));
      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            jsonDecode(response.body)['metadata'];
        List<String> categories = [];
        for (var category in responseData) {
          categories.add(category);
        }
        return categories;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<void> syncLocalRecipeBackLogin() async {
    final Map<String, String> userLocal = await UserLocal.getUserInfo();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/recipe/'),
        headers: {
          'x-api-key': Constants.apiKey,
          'content-type': 'application/json',
          'authorization': userLocal['accessToken'] ?? '',
          'x-client-id': userLocal['userId'] ?? '',
        },
      ).timeout(Duration(seconds: 4));
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> recipes = data['metadata'];

        // Mở Hive box
        final box = Hive.box<Recipes>('recipeBox');
        print('111111111== ddang sync');

        // Thêm dữ liệu vào Hive box
        for (var recipeData in recipes) {
          final recipeId = recipeData['_id'];
          // Kiểm tra xem công thức đã tồn tại trong box chưa
          if (true) {
            final recipe = Recipes(
              name: recipeData['recipe_name'],
              description: recipeData['recipe_description'],
              ingredients: (recipeData['recipe_ingredients'] as List)
                  .map((ingredientData) {
                return FridgeIngredient(
                  name: ingredientData['name'],
                  quantity: ingredientData['quantity'] ?? '0',
                  unit: ingredientData['unit'] ?? '',
                );
              }).toList(),
              timeCooking: recipeData['recipe_cook_time'],
              recipeYoutubeUrl: recipeData['recipe_youtube_url'],
              rating: recipeData['recipe_rating'].toString(),
              category: recipeData['recipe_category'],
              imgPath: recipeData['recipe_image'],
            );
            recipe.id == recipeId;
            print(recipe);
            await box.add(recipe);
          }
        }
        print('da xong recipe');
        print(box.values.toList().toString());
      } else {}
    } catch (e) {
      print('Co loi');
      print(e);
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
      ).timeout(Duration(seconds: 10));
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

    //server
    final Map<String, String> userLocal = await UserLocal.getUserInfo();
    final response = await http.delete(
      Uri.parse('$baseUrl/recipe/${recipe.id}'),
      headers: {
        'x-api-key': Constants.apiKey,
        'content-type': 'application/json',
        'authorization': userLocal['accessToken'] ?? '',
        'x-client-id': userLocal['userId'] ?? '',
      },
    ).timeout(Duration(seconds: 4));
    if (response.statusCode == 200) {
      print('delete OK');
    } else {
      print('not sync type:: ${recipe.type}');
    }
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
    final Map<String, String> userLocal = await UserLocal.getUserInfo();
    //db
    await _recipeBox.put(recipe.name, recipe);

    final response = await http
        .post(
          Uri.parse('$baseUrl/recipe'),
          headers: {
            'x-api-key': Constants.apiKey,
            'content-type': 'application/json',
            'authorization': userLocal['accessToken'] ?? '',
            'x-client-id': userLocal['userId'] ?? '',
          },
          body: jsonEncode(convertToBody(recipe)),
        )
        .timeout(Duration(seconds: 4));
    if (response.statusCode == 200) {
      //sync OK
      final Map<String, dynamic> responseData =
          jsonDecode(response.body)['metadata'];
      recipe.sync = true;
      recipe.id = responseData['_id'].toString();
      print('====${recipe.id} == sync${recipe.sync} OK');
      await _recipeBox.put(recipe.name, recipe);
    } else {
      print('not sync type:: ${recipe.type}');
    }
  }
}

Map<String, Object> convertToBody(Recipes recipe) {
  return {
    "recipe_name": recipe.name,
    "recipe_description": recipe.description,
    "recipe_ingredients": recipe.ingredients
        .map((ingredient) => {
              "name": ingredient.name,
              "quantity": ingredient.quantity
                  .split(' ')[0], // Assuming quantity is in the format "2 con"
              "unit": ingredient.quantity.split(' ')[1], // Extracting unit
              "category": "unknown",
            })
        .toList(),
    "recipe_cook_time": recipe.timeCooking,
    "recipe_youtube_url": recipe.recipeYoutubeUrl,
    "recipe_rating": double.tryParse(recipe.rating) ?? 0.0,
    "recipe_category":
        recipe.category.isEmpty ? 'Được chia sẻ' : recipe.category.isEmpty,
    "recipe_image": recipe.imgPath,
    "is_published": false,
    "is_draft": true,
    "recipe_id_crawl": "x"
  };
}
