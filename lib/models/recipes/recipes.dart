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

  @HiveField(6)
  String category;
  @HiveField(7)
  String recipeYoutubeUrl;
  @HiveField(8)
  bool isFavorite = false;

  Recipes(
      {required this.name,
      required this.description,
      required this.imgPath,
      required this.rating,
      required this.timeCooking,
      required this.ingredients,
      this.category = '',
      this.recipeYoutubeUrl = ''});

  @override
  String toString() {
    return 'Recipes{name: $name, description: $description, imgPath: $imgPath, rating: $rating, timeCooking: $timeCooking, ingredients: $ingredients} $isFavorite';
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
      name: json['recipe_name']?.toString() ?? '',
      description: json['recipe_desciption']?.toString() ?? '',
      imgPath: json['recipe_image']?.toString() ?? '',
      rating: json['recipe_rating']?.toString() ?? '4.5',
      timeCooking: json['recipe_cook_time']?.toString() ?? '',
      category: json['recipe_category']?.toString() ?? '',
      ingredients: (json['recipe_ingredients'] as List<dynamic>?)
              ?.map((ingredientJson) => FridgeIngredient(
                    name: ingredientJson['name']?.toString() ?? '',
                    quantity: ingredientJson['quantity']?.toString() ?? '',
                    unit: ingredientJson['unit']?.toString() ?? '',
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
