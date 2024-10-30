import 'package:benri_app/models/ingredients/basket_ingredients.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BasketService {
  static Map<String, List<BasketIngredient>> baskets = {};
  final _basketBox = Hive.box('basketBox');

  static Future<void> loadData() async {}
}
