import 'package:benri_app/models/baskets/baskets.dart';
import 'package:benri_app/models/ingredients/basket_ingredients.dart';
import 'package:benri_app/views/widgets/add_ingredient_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BasketService {
  static Map<String, Basket> baskets = {};
  static final _basketBox = Hive.box<Basket>('basketBox');

  static Future<void> initializeLocalData() async {
    await _loadDatabase();
    if (_basketBox.get('isFirstTime') == null) {
      _basketBox.put('isFirstTime',
          new Basket(date: '', basketIngredients: [], totalMoney: ''));
    }
  }

  static Future<void> _loadDatabase() async {
    // load from local
    for (int i = 0; i < _basketBox.length; i++) {
      final basket = _basketBox.getAt(i);
      if (basket != null) {
        baskets[basket.date] = basket;
      }
    }
  }

  static Future<void> _updateLocalDatabase() async {
    await _basketBox.clear();
    await _basketBox.putAll(baskets);
  }

  static Future<void> initializeBasketsForDate(String date) async {
    if (!baskets.containsKey(date)) {
      baskets[date] =
          new Basket(date: date, basketIngredients: [], totalMoney: '0');
    }
  }

  static Future<void> addIngredient(
      String date, BasketIngredient basketIngredient) async {
    // add in local
    await initializeBasketsForDate(date);
    baskets[date]!.basketIngredients.add(basketIngredient);
    await _updateLocalDatabase();
  }

  static Future<void> toggleIngredientSelection(String date, int index) async {
    // toggle in local
    if (index >= 0 && index < baskets[date]!.basketIngredients.length) {
      baskets[date]!.basketIngredients[index].isSelected =
          baskets[date]!.basketIngredients[index].isSelected;
      await _updateLocalDatabase();
    }
  }

  static Future<void> deleteBasketItem(String date, int index) async {
    // delete in local
    if (index >= 0 && index < baskets[date]!.basketIngredients.length) {
      baskets[date]!.basketIngredients.removeAt(index);
      await _updateLocalDatabase();
    }
  }

  static Future<void> editBasketItem(
      BuildContext context, String date, int index) async {
    // edit in local
    if (index >= 0 && index < baskets[date]!.basketIngredients!.length) {
      BasketIngredient currentIngredient =
          baskets[date]!.basketIngredients[index];

      BasketIngredient? updatedIngredient =
          await addIngredientDialog(context, ingredient: currentIngredient);

      if (updatedIngredient != null) {
        baskets[date]!.basketIngredients[index] = updatedIngredient;
        await _updateLocalDatabase();
      }
    }
  }
}
