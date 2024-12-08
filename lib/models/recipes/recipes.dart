import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:hive/hive.dart';

part 'recipes.g.dart';

@HiveType(typeId: 4)
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

  @override
  String toString() {
    return 'Recipes{name: $name, description: $description, imgPath: $imgPath, rating: $rating, timeCooking: $timeCooking, ingredients: $ingredients}';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imgPath': imgPath,
      'rating': rating,
      'timeCooking': timeCooking,
      'ingredients': ingredients
          .map((ingredient) => {
                'name': ingredient.name,
                'quantity': ingredient.quantity,
                'imgPath': ingredient.imgPath,
                'expirationDate': ingredient.expirationDate?.toIso8601String(),
              })
          .toList(),
    };
  }

  factory Recipes.fromJson(Map<String, dynamic> json) {
    return Recipes(
      name: json['name'] as String,
      description: json['description'] as String,
      imgPath: json['imgPath'] as String,
      rating: json['rating'] as String,
      timeCooking: json['timeCooking'] as String,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((ingredientJson) => FridgeIngredient(
                    name: ingredientJson['name'] as String,
                    quantity: ingredientJson['quantity'] as String,
                    imgPath: ingredientJson['imgPath'] as String,
                    expirationDate: ingredientJson['expirationDate'] != null
                        ? DateTime.parse(
                            ingredientJson['expirationDate'] as String)
                        : null,
                  ))
              .toList() ??
          [],
    );
  }
}
