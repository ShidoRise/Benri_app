import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FridgeIngredientLocalDb {
  Map<String, List<FridgeIngredient>> fridgeIngredients =
      {}; // Store as FridgeIngredient
  final _fridgeIngredientBox = Hive.box('fridgeIngredientBox'); // Updated box

  void createInitialData() {
    fridgeIngredients = {};
  }

  void loadData() {
    final loadedData =
        _fridgeIngredientBox.get('FRIDGEINGREDIENTLIST'); // Updated key
    if (loadedData != null) {
      fridgeIngredients = Map<String, List<FridgeIngredient>>.from(
          (loadedData as Map).map((key, value) => MapEntry(
              key as String,
              List<FridgeIngredient>.from(value.map((item) => FridgeIngredient(
                    name: item['name'],
                    quantity: item['quantity'],
                    imgPath: item['imgPath'],
                    expirationDate: DateTime.parse(
                        item['expirationDate']), // Parse to DateTime
                  ))))));
    }
  }

  void updateDatabase() {
    _fridgeIngredientBox.put(
      'FRIDGEINGREDIENTLIST', // Updated key
      fridgeIngredients.map((key, value) => MapEntry(
          key,
          value
              .map((ingredient) => {
                    'name': ingredient.name,
                    'quantity': ingredient.quantity,
                    'imgPath': ingredient.imgPath,
                    'expirationDate': ingredient.expirationDate
                        ?.toIso8601String(), // Store as String
                  })
              .toList())),
    );
  }
}
