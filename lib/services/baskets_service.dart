import 'dart:convert';

import 'package:benri_app/models/baskets/baskets.dart';
import 'package:benri_app/models/ingredients/basket_ingredients.dart';
import 'package:benri_app/services/user_local.dart';
import 'package:benri_app/utils/constants/constant.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:benri_app/views/widgets/add_ingredient_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BasketService {
  static Map<String, Basket> baskets = {};
  static final _basketBox = Hive.box<Basket>('basketBox');
  static final String baseUrl = dotenv.get('API_URL');

  BasketService._();

  static Future<void> initializeLocalData() async {
    await _loadDatabase();
    if (_basketBox.get('isFirstTime') == null) {
      _basketBox.put('isFirstTime',
          Basket(date: '', basketIngredients: [], totalMoney: ''));
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
          Basket(date: date, basketIngredients: [], totalMoney: '0');
    }
  }

  static Future<void> addIngredient(
      String date, BasketIngredient basketIngredient) async {
    // add in local
    await initializeBasketsForDate(date);
    baskets[date]!.basketIngredients.add(basketIngredient);
    await _updateLocalDatabase();

    // add in remote
    if (baskets[date]!.id == 'empty') {
      await createBasketServer(baskets[date]!);
    } else {
      baskets[date]!.sync = false;
      await updateBasketServer(baskets[date]!);
    }
  }

  static Future<void> toggleIngredientSelection(String date, int index) async {
    // toggle in local
    if (index >= 0 && index < baskets[date]!.basketIngredients.length) {
      baskets[date]!.basketIngredients[index].isSelected =
          !baskets[date]!.basketIngredients[index].isSelected;
      await _updateLocalDatabase();
    }
  }

  static Future<void> deleteBasketItem(String date, int index) async {
    // delete in local
    if (index >= 0 && index < baskets[date]!.basketIngredients.length) {
      baskets[date]!.basketIngredients.removeAt(index);
      await _updateLocalDatabase();
      await deleteBasketServer(baskets[date]!);
    }
  }

  static Future<void> editBasketItem(
      BuildContext context, String date, int index) async {
    // edit in local
    if (index >= 0 && index < baskets[date]!.basketIngredients.length) {
      BasketIngredient currentIngredient =
          baskets[date]!.basketIngredients[index];

      final basketViewModel =
          Provider.of<BasketViewModel>(context, listen: false);

      if (basketViewModel.unitOptions.contains(currentIngredient.unit)) {
        basketViewModel.updateSelectedUnit(currentIngredient.unit);
      }

      if (basketViewModel.categories.contains(currentIngredient.category)) {
        basketViewModel.updateSelectedCategory(currentIngredient.category);
      }

      BasketIngredient? updatedIngredient =
          await addIngredientDialog(context, ingredient: currentIngredient);

      if (updatedIngredient != null) {
        baskets[date]!.basketIngredients[index] = updatedIngredient;
        baskets[date]!.sync = false;
        baskets[date]!.type = 'update';
        await _updateLocalDatabase();

        //remote
        await updateBasketServer(baskets[date]!);
      }

      basketViewModel.resetSelections();
    }
  }

  static Future<void> updateTotalMoney(String date, String totalMoney) async {
    if (baskets.containsKey(date)) {
      baskets[date]!.totalMoney = totalMoney;
      await _updateLocalDatabase();
    }
  }

  static Future<void> updateBasketServer(Basket basket) async {
    final Map<String, String> userLocal = await UserLocal.getUserInfo();
    try {
      final response = await http
          .patch(
            Uri.parse('$baseUrl/baskets/${basket.id}'),
            headers: {
              'x-api-key': Constants.apiKey,
              'content-type': 'application/json',
              'authorization': userLocal['accessToken'] ?? '',
              'x-client-id': userLocal['userId'] ?? '',
            },
            body: jsonEncode({
              "name": basket.date,
              "description": "",
              "ingredients": basket.basketIngredients
                  .map((item) => {
                        "name": item.name,
                        "quantity": item.quantity,
                        "unit": item.unit,
                        "category": item.category
                      })
                  .toList(),
              "totalMoney": basket.totalMoney
            }),
          )
          .timeout(Duration(seconds: 4));
      if (response.statusCode == 200) {
        //sync OK
        final Map<String, dynamic> responseData =
            jsonDecode(response.body)['metadata'];
        // await _recipeBox.put(recipe.name, recipe);
        print('==== ${responseData['basketId']}');
        baskets[basket.date]!.sync = true;
        await _updateLocalDatabase();
      } else {}
    } catch (e) {}
  }

  static Future<void> deleteBasketServer(Basket basket) async {
    final Map<String, String> userLocal = await UserLocal.getUserInfo();
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/baskets/${basket.id}'),
        headers: {
          'x-api-key': Constants.apiKey,
          'content-type': 'application/json',
          'authorization': userLocal['accessToken'] ?? '',
          'x-client-id': userLocal['userId'] ?? '',
        },
      ).timeout(Duration(seconds: 4));
      if (response.statusCode == 200) {
        //sync OK
        final Map<String, dynamic> responseData =
            jsonDecode(response.body)['metadata'];
        // await _recipeBox.put(recipe.name, recipe);
        print('==== ${responseData['basketId']}');
        baskets[basket.date]!.sync = true;
        baskets[basket.date]!.type = 'delete';
        await _updateLocalDatabase();
      } else {}
    } catch (e) {}
  }

  static Future<void> createBasketServer(Basket basket) async {
    final Map<String, String> userLocal = await UserLocal.getUserInfo();
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/baskets'),
            headers: {
              'x-api-key': Constants.apiKey,
              'content-type': 'application/json',
              'authorization': userLocal['accessToken'] ?? '',
              'x-client-id': userLocal['userId'] ?? '',
            },
            body: jsonEncode({
              "name": basket.date,
              "description": "",
              "ingredients": basket.basketIngredients
                  .map((item) => {
                        "name": item.name,
                        "quantity": item.quantity,
                        "unit": item.unit,
                        "category": item.category
                      })
                  .toList(),
              "totalMoney": basket.totalMoney
            }),
          )
          .timeout(Duration(seconds: 4));
      print(response.body);
      print(basket.basketIngredients);
      if (response.statusCode == 200) {
        //sync OK
        final Map<String, dynamic> responseData =
            jsonDecode(response.body)['metadata'];
        // await _recipeBox.put(recipe.name, recipe);
        print('==== ${responseData['basketId']}');
        baskets[basket.date]!.sync = true;
        baskets[basket.date]!.id = responseData['basketId'];

        await _updateLocalDatabase();
      } else {}
    } catch (e) {}
  }
}
