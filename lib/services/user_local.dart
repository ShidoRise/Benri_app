import 'package:benri_app/models/baskets/baskets.dart';
import 'package:benri_app/models/fridge_drawers/fridge_drawers.dart';
import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/services/auth_service.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocal {
  UserLocal._();

  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('chat_history');
      await AuthService.storage.deleteAll();
      //
      await Hive.box('fridgeIngredientBox').clear();
      await Hive.box<Basket>('basketBox').clear();
      await Hive.box<Recipes>('recipeBox').clear();
      await Hive.box<FridgeDrawer>('fridgeDrawerBox').clear();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  static Future<Map<String, String>> getUserInfo() async {
    try {
      String userId = await AuthService.storage.read(key: 'userId') ?? '';
      String refreshToken =
          await AuthService.storage.read(key: 'refreshToken') ?? '';
      String accessToken =
          await AuthService.storage.read(key: 'accessToken') ?? '';
      String email = await AuthService.storage.read(key: 'email') ?? '';
      String name = await AuthService.storage.read(key: 'name') ?? '';

      Map<String, String> data = {
        'userId': userId,
        'refreshToken': refreshToken,
        'accessToken': accessToken,
        'email': email,
        'name': name
      };
      return data;
    } catch (e) {
      print('Error retrieving user info: $e');
      return {};
    }
  }
}
