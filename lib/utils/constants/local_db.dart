import 'package:benri_app/models/ingredients/basket_ingredients.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BasketsLocalDB {
  Map<String, List<BasketIngredient>> baskets = {};
  final _basketBox = Hive.box('basketBox');

  void createInitialData() {
    baskets = {};
  }

  void loadData() {
    final loadedData = _basketBox.get('BASKETSLIST');
    if (loadedData != null) {
      baskets = Map<String, List<BasketIngredient>>.from((loadedData as Map)
          .map((key, value) => MapEntry(
              key as String,
              List<BasketIngredient>.from(
                  value.map((ingredient) => BasketIngredient(
                        name: ingredient['name'],
                        isSelected: ingredient['isSelected'] as bool,
                        quantity: ingredient['quantity'],
                        unit: ingredient['unit'],
                        imageUrl: ingredient['imageUrl'],
                      ))))));
    }
  }

  void updateDatabase() {
    _basketBox.put(
        'BASKETSLIST',
        baskets.map((key, value) => MapEntry(
            key,
            value
                .map((ingredient) => {
                      'name': ingredient.name,
                      'isSelected': ingredient.isSelected,
                      'quantity': ingredient.quantity,
                      'unit': ingredient.unit,
                      'imageUrl': ingredient.imageUrl,
                    })
                .toList())));
  }
}
