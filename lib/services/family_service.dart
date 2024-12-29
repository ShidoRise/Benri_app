import 'package:benri_app/models/families/family_ingredients.dart';
import 'package:benri_app/models/families/family_lists.dart';
import 'package:benri_app/models/families/family_members.dart';
import 'package:benri_app/services/auth_service.dart';
import 'package:benri_app/services/user_local.dart';
import 'package:benri_app/utils/constants/constant.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:benri_app/views/widgets/add_family_ingredient_dialog.dart';
import 'package:benri_app/views/widgets/choose_member_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class FamilyService {
  static List<FamilyMember> familyMembers = [];
  static Map<String, FamilyList> familyShoppingListData = {};
  static final String baseUrl = dotenv.get('API_URL');

  FamilyService._();

  static Future<void> createFamily(String famName) async {
    try {
      final Map<String, String> userLocal = await UserLocal.getUserInfo();

      final response = await http.post(
        Uri.parse('$baseUrl/family'),
        headers: {
          'x-api-key': Constants.apiKey,
          'x-client-id': userLocal['userId'] ?? '',
          'x-rtoken-id': userLocal['refreshToken'] ?? '',
          'content-type': 'application/json'
        },
        body: jsonEncode({
          'fam_name': famName,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        final metadata = responseData['metadata'];

        await AuthService.storage
            .write(key: 'familyId', value: metadata['family_id']);
        await AuthService.storage
            .write(key: 'family_code', value: metadata['code']);
        await AuthService.storage.write(key: 'familyRole', value: 'admin');
      } else {
        throw Exception('Failed to create family: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating family: $e');
    }
  }

  static Future<void> joinFamily(String famCode) async {
    try {
      final Map<String, String> userLocal = await UserLocal.getUserInfo();

      final response = await http.post(
        Uri.parse('$baseUrl/family/join'),
        headers: {
          'x-api-key': Constants.apiKey,
          'x-client-id': userLocal['userId'] ?? '',
          'x-rtoken-id': userLocal['refreshToken'] ?? '',
          'content-type': 'application/json'
        },
        body: jsonEncode({
          'code': famCode,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        final metadata = responseData['metadata'];

        await AuthService.storage
            .write(key: 'familyId', value: metadata['famlily_id']);
        await AuthService.storage.write(key: 'familyRole', value: 'member');
      } else {
        throw Exception('Failed to join family: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error joining family: $e');
    }
  }

  static Future<void> getFamily(String familyId) async {
    try {
      final Map<String, String> userLocal = await UserLocal.getUserInfo();

      final response = await http.get(
        Uri.parse('$baseUrl/family/$familyId'),
        headers: {
          'x-api-key': Constants.apiKey,
          'x-client-id': userLocal['userId'] ?? '',
          'x-rtoken-id': userLocal['refreshToken'] ?? '',
          'content-type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final metadata = responseData['metadata'];
        await AuthService.storage
            .write(key: 'family_code', value: metadata['code']);

        final members = metadata['fam_members'] as List;
        familyMembers =
            members.map((member) => FamilyMember.fromJson(member)).toList();
      } else {
        throw Exception('Failed to get family: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting family: $e');
    }
  }

  static Future<void> deleteFamily() async {
    try {
      final Map<String, String> userLocal = await UserLocal.getUserInfo();
      final familyId = await AuthService.storage.read(key: 'familyId');
      if (familyId == null) throw Exception('No family ID found');

      final response = await http.delete(
        Uri.parse('$baseUrl/family/$familyId'),
        headers: {
          'x-api-key': Constants.apiKey,
          'x-client-id': userLocal['userId'] ?? '',
          'x-rtoken-id': userLocal['refreshToken'] ?? '',
          'content-type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        await AuthService.storage.delete(key: 'familyId');
        await AuthService.storage.delete(key: 'family_code');
        await AuthService.storage.delete(key: 'familyRole');

        familyShoppingListData.clear();
        familyMembers.clear();
      } else {
        throw Exception('Failed to delete family: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting family: $e');
      throw Exception('Error deleting family: $e');
    }
  }

  static Future<void> leaveFamily() async {
    try {
      final Map<String, String> userLocal = await UserLocal.getUserInfo();
      final familyId = await AuthService.storage.read(key: 'familyId');
      if (familyId == null) throw Exception('No family ID found');

      final response = await http.post(
        Uri.parse('$baseUrl/family/leave/$familyId'),
        headers: {
          'x-api-key': Constants.apiKey,
          'x-client-id': userLocal['userId'] ?? '',
          'x-rtoken-id': userLocal['refreshToken'] ?? '',
          'content-type': 'application/json'
        },
      );

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        await AuthService.storage.delete(key: 'familyId');
        await AuthService.storage.delete(key: 'family_code');
        await AuthService.storage.delete(key: 'familyRole');

        familyShoppingListData.clear();
        familyMembers.clear();
      } else {
        throw Exception('Failed to leave family: ${response.statusCode}');
      }
    } catch (e) {
      print('Error leaving family: $e');
      throw Exception('Failed to leave family: $e');
    }
  }

  static Future<String?> getFamilyCode() async {
    try {
      final familyCode = await AuthService.storage.read(key: 'family_code');
      return familyCode;
    } catch (e) {
      print('Error getting family code: $e');
      return null;
    }
  }

  static Future<void> getFamilyShoppingLists() async {
    try {
      final Map<String, String> userLocal = await UserLocal.getUserInfo();
      final familyId = await AuthService.storage.read(key: 'familyId');
      if (familyId == null) throw Exception('No family ID found');

      final response = await http.get(
        Uri.parse('$baseUrl/family/$familyId/shopping-lists'),
        headers: {
          'x-api-key': Constants.apiKey,
          'x-client-id': userLocal['userId'] ?? '',
          'x-rtoken-id': userLocal['refreshToken'] ?? '',
          'content-type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> metadata = jsonDecode(response.body)['metadata'];
        familyShoppingListData.clear();
        for (var list in metadata) {
          familyShoppingListData[list['name']] = FamilyList.fromJson(list);
        }
      } else {
        throw Exception('Failed to get shopping lists: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting family shopping lists: $e');
      throw Exception('Failed to get family shopping lists');
    }
  }

  static Future<void> postFamilyShoppingList(
      String date, FamilyIngredient ingredient) async {
    try {
      final Map<String, String> userLocal = await UserLocal.getUserInfo();

      final familyId = await AuthService.storage.read(key: 'familyId');
      if (familyId == null) throw Exception('No family ID found');

      final response = await http.post(
        Uri.parse('$baseUrl/family/$familyId/shopping-lists'),
        headers: {
          'x-api-key': Constants.apiKey,
          'x-client-id': userLocal['userId'] ?? '',
          'x-rtoken-id': userLocal['refreshToken'] ?? '',
          'content-type': 'application/json'
        },
        body: jsonEncode({
          'name': date,
          'description': 'Created shopping list',
          'ingredients': [
            {
              'name': ingredient.name,
              'quantity': ingredient.quantity,
              'category': ingredient.category,
              'unit': ingredient.unit,
              'status': 'pending',
            }
          ],
        }),
      );
      print(response.body);

      if (response.statusCode == 200) {
        final metadata = jsonDecode(response.body)['metadata'];

        familyShoppingListData[date]!.listId = metadata['list_id'];
      } else {
        throw Exception('Failed to create shopping list');
      }
    } catch (e) {
      print('Error posting shopping list: $e');
      throw Exception('Failed to post shopping list');
    }
  }

  static Future<void> updateFamilyShoppingList({
    required String familyId,
    required String listId,
    required String name,
    required String description,
    required List<FamilyIngredient> ingredients,
    required String userId,
  }) async {
    int retryCount = 0;
    const maxRetries = 3;
    const timeout = Duration(seconds: 30);
    try {
      final Map<String, String> userLocal = await UserLocal.getUserInfo();

      final response = await http
          .patch(
            Uri.parse('$baseUrl/family/$familyId/shopping-lists/$listId'),
            headers: {
              'x-api-key': Constants.apiKey,
              'x-client-id': userLocal['userId'] ?? '',
              'x-rtoken-id': userLocal['refreshToken'] ?? '',
              'content-type': 'application/json'
            },
            body: jsonEncode({
              'name': name,
              'workerId': userId,
              'description': description,
              'ingredients': ingredients
                  .map((ingredient) => {
                        'name': ingredient.name,
                        'quantity': ingredient.quantity,
                        'category': ingredient.category,
                        'unit': ingredient.unit,
                        'status': ingredient.status ? 'bought' : 'pending',
                      })
                  .toList(),
            }),
          )
          .timeout(timeout);

      if (response.statusCode != 200) {
        throw Exception('Failed to update shopping list');
      }
    } catch (e) {
      retryCount++;
      if (retryCount == maxRetries) {
        throw Exception(
            'Failed to update shopping list after $maxRetries attempts: $e');
      }
      await Future.delayed(Duration(seconds: retryCount * 2));
    }
  }

  static Future<void> addFamilyIngredient(
      String date, FamilyIngredient ingredient) async {
    if (!familyShoppingListData.containsKey(date)) {
      final Map<String, String> userLocal = await UserLocal.getUserInfo();
      familyShoppingListData[date] = FamilyList(
        listId: '',
        userId: userLocal['userId'] ?? '',
        ingredients: <FamilyIngredient>[
          FamilyIngredient(
              name: ingredient.name,
              quantity: ingredient.quantity,
              category: ingredient.category,
              unit: ingredient.unit,
              status: false)
        ],
      );
      await postFamilyShoppingList(date, ingredient);
    } else {
      final currentList = familyShoppingListData[date];
      if (currentList != null) {
        final updatedIngredients = [...currentList.ingredients, ingredient];
        familyShoppingListData[date] = FamilyList(
          listId: currentList.listId,
          userId: currentList.userId,
          ingredients: updatedIngredients,
        );
      }

      final familyId = await AuthService.storage.read(key: 'familyId');
      if (familyId == null) throw Exception('No family ID found');

      await updateFamilyShoppingList(
        familyId: familyId,
        listId: familyShoppingListData[date]!.listId,
        name: date,
        description: 'Added shopping list',
        ingredients: familyShoppingListData[date]!.ingredients,
        userId: familyShoppingListData[date]!.userId,
      );
    }
  }

  static Future<void> deleteFamilyItem(String date, int index) async {
    if (familyShoppingListData.containsKey(date) &&
        index >= 0 &&
        index < familyShoppingListData[date]!.ingredients.length) {
      familyShoppingListData[date]!.ingredients.removeAt(index);

      final familyId = await AuthService.storage.read(key: 'familyId');
      if (familyId == null) throw Exception('No family ID found');

      await updateFamilyShoppingList(
        familyId: familyId,
        listId: familyShoppingListData[date]!.listId,
        name: date,
        description: 'Deleted shopping list',
        ingredients: familyShoppingListData[date]!.ingredients,
        userId: familyShoppingListData[date]!.userId,
      );
    }
  }

  static Future<void> editFamilyItem(
      BuildContext context, String date, int index) async {
    if (familyShoppingListData.containsKey(date) &&
        index >= 0 &&
        index < familyShoppingListData[date]!.ingredients.length) {
      final currentIngredient =
          familyShoppingListData[date]!.ingredients[index];

      final basketViewModel =
          Provider.of<BasketViewModel>(context, listen: false);

      basketViewModel.resetSelections();

      if (basketViewModel.unitOptions.contains(currentIngredient.unit)) {
        basketViewModel.updateSelectedUnit(currentIngredient.unit);
      }

      if (basketViewModel.categories.contains(currentIngredient.category)) {
        basketViewModel.updateSelectedCategory(currentIngredient.category);
      }

      final updatedIngredient = await addFamilyIngredientDialog(
          context, 'Sửa nguyên liệu',
          ingredient: currentIngredient);

      if (updatedIngredient != null) {
        familyShoppingListData[date]!.ingredients[index] = updatedIngredient;

        final familyId = await AuthService.storage.read(key: 'familyId');
        if (familyId == null) throw Exception('No family ID found');

        await updateFamilyShoppingList(
          familyId: familyId,
          listId: familyShoppingListData[date]!.listId,
          name: date,
          description: 'Edited shopping list',
          ingredients: familyShoppingListData[date]!.ingredients,
          userId: familyShoppingListData[date]!.userId,
        );

        basketViewModel.resetSelections();
      }
    }
  }

  static Future<void> toggleFamilyIngredientSelection(
      String date, int index) async {
    if (index >= 0 &&
        index < familyShoppingListData[date]!.ingredients.length) {
      familyShoppingListData[date]!.ingredients[index].status =
          !familyShoppingListData[date]!.ingredients[index].status;

      final familyId = await AuthService.storage.read(key: 'familyId');
      if (familyId == null) throw Exception('No family ID found');

      await updateFamilyShoppingList(
        familyId: familyId,
        listId: familyShoppingListData[date]!.listId,
        name: date,
        description: 'Toggled shopping list',
        ingredients: familyShoppingListData[date]!.ingredients,
        userId: familyShoppingListData[date]!.userId,
      );
    }
  }

  static Future<void> chooseFamilyMemberBuyIngredients(
      BuildContext context, String date) async {
    if (familyShoppingListData.containsKey(date)) {
      final userId = await showChooseMemberDialog(context);
      if (userId != null) {
        familyShoppingListData[date]!.userId = userId;

        final familyId = await AuthService.storage.read(key: 'familyId');
        if (familyId == null) throw Exception('No family ID found');

        try {
          final Map<String, String> userLocal = await UserLocal.getUserInfo();

          final response = await http.post(
              Uri.parse(
                  '$baseUrl/family/$familyId/assign-task/$userId/${familyShoppingListData[date]!.listId}'),
              headers: {
                'x-api-key': Constants.apiKey,
                'x-client-id': userLocal['userId'] ?? '',
                'x-rtoken-id': userLocal['refreshToken'] ?? '',
                'content-type': 'application/json'
              },
              body: jsonEncode({
                'taskDetails': 'Bạn được giao đi chợ vào ngày $date',
              }));

          if (response.statusCode != 200) {
            throw Exception('Failed to choose family member assign task');
          }
        } catch (e) {
          print('Error choose family member assign task: $e');
        }
      }
    }
  }
}
