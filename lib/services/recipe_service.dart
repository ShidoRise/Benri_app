import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/utils/constants/fridge_ingredient_local_db.dart';
import 'package:hive/hive.dart';

class RecipeService {
  static const String _boxName = 'recipeBox';
  final FridgeIngredientLocalDb _fridgeDBb = FridgeIngredientLocalDb();

  Future<Box<Recipes>> _openBox() async {
    return await Hive.openBox<Recipes>(_boxName);
  }

  Future<List<Recipes>> getAllRecipes() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> addRecipe(Recipes recipe) async {
    final box = await _openBox();
    box.add(recipe);
  }

  Future<void> removeRecipe(Recipes recipe) async {
    final box = await _openBox();
    box.delete(recipe);
  }

  Future<void> updateRecipe(Recipes recipe) async {
    final box = await _openBox();
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
