import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:hive/hive.dart';

part 'recipes.g.dart';

@HiveType(typeId: 3) // Assign a unique type ID for each model
class Recipes extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  String imgPath;

  @HiveField(3)
  String rating;

  @HiveField(4)
  String timeCooking;

  @HiveField(5)
  List<FridgeIngredient> ingredients;

  Recipes({
    required this.name,
    required this.description,
    required this.imgPath,
    required this.rating,
    required this.timeCooking,
    required this.ingredients,
  });
}
