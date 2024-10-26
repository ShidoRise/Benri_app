import 'package:benri_app/models/ingredients/ingredients.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BasketsLocalDB {
  Map<String, List<Ingredient>> baskets = {};
  final _basketBox = Hive.box('basketBox');

  void createInitialData() {
    baskets = {};
  }

  void loadData() {
    final loadedData = _basketBox.get('BASKETSLIST');
    if (loadedData != null) {
      baskets = Map<String, List<Ingredient>>.from(
          (loadedData as Map).map((key, value) => MapEntry(
              key as String,
              List<Ingredient>.from(value.map((item) => Ingredient(
                    name: item['name'],
                    isSelected: item['isSelected'] as bool,
                    quantity: item['quantity'],
                    unit: item['unit'],
                    imageUrl: item['imageUrl'],
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
