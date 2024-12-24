import 'package:benri_app/models/families/family_ingredients.dart';

class FamilyList {
  final String listId;
  String userId;
  final List<FamilyIngredient> ingredients;

  FamilyList({
    required this.listId,
    required this.userId,
    required this.ingredients,
  });

  factory FamilyList.fromJson(Map<String, dynamic> json) {
    return FamilyList(
      listId: json['list_id'] ?? '',
      userId: json['created_by'] ?? '',
      ingredients: (json['ingredients'] as List)
          .map((i) => FamilyIngredient.fromJson(i))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'FamilyList(listId: $listId, ingredients: $ingredients)';
  }
}
