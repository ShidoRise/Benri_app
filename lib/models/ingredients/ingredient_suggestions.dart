import 'package:hive/hive.dart';

part 'ingredient_suggestions.g.dart';

@HiveType(typeId: 2)
class IngredientSuggestion {
  @HiveField(0)
  String name;

  @HiveField(1)
  String thumbnailUrl;

  @HiveField(2)
  String nameInVietnamese;

  IngredientSuggestion({
    required this.name,
    required this.thumbnailUrl,
    required this.nameInVietnamese,
  });

  @override
  String toString() {
    return 'IngredientSuggestion{name: $name, nameInVietnamese: $nameInVietnamese, thumbnailUrl: $thumbnailUrl}';
  }
}
