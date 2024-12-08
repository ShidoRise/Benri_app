import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:hive/hive.dart';

part 'fridge_drawers.g.dart';

@HiveType(typeId: 5)
class FridgeDrawer {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final List<FridgeIngredient> fridgeIngredients;

  FridgeDrawer({
    required this.name,
    required this.fridgeIngredients,
  });

  @override
  String toString() {
    return 'FridgeDrawer{name: $name, fridgeIngredients: $fridgeIngredients}';
  }
}
