import 'package:benri_app/models/ingredients/ingredients.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BasketsLocalDB {
  Map<String, List<Ingredient>> baskets = {};
  final _myBox = Hive.box('mybox');

  void createInitialData() {
    baskets = {
      "10/16/2024": [
        Ingredient(name: 'Banana'),
        Ingredient(name: 'Apples'),
        Ingredient(name: 'Potatoes'),
        Ingredient(name: 'Oranges'),
      ],
      "10/17/2024": [
        Ingredient(name: 'Helo'),
        Ingredient(name: 'Appes'),
        Ingredient(name: 'Poatoes'),
        Ingredient(name: 'Ornges'),
      ],
    };
  }

  void loadData() {
    final loadedData = _myBox.get('BASKETSLIST');
    if (loadedData != null) {
      baskets = Map<String, List<Ingredient>>.from(
          (loadedData as Map).map((key, value) => MapEntry(
              key as String,
              List<Ingredient>.from(value.map((item) => Ingredient(
                    name: item['name'],
                    isSelected: item['isSelected'] as bool,
                  ))))));
    }
  }

  void updateDatabase() {
    _myBox.put(
        'BASKETSLIST',
        baskets.map((key, value) => MapEntry(
            key,
            value
                .map((ingredient) => {
                      'name': ingredient.name,
                      'isSelected': ingredient.isSelected,
                    })
                .toList())));
  }
}
