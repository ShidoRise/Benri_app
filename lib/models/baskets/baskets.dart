import 'package:benri_app/models/ingredients/basket_ingredients.dart';
import 'package:hive/hive.dart';

part 'baskets.g.dart';

@HiveType(typeId: 0)
class Basket {
  @HiveField(0)
  String date;

  @HiveField(1)
  List<BasketIngredient> basketIngredients;

  @HiveField(2)
  String totalMoney;

  Basket({
    required this.date,
    required this.basketIngredients,
    required this.totalMoney,
  });

  @override
  String toString() {
    return 'Basket{date: $date, basketIngredients: $basketIngredients, totalMoney: $totalMoney}';
  }
}
