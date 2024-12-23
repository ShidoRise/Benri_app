import 'package:benri_app/models/families/family_ingredients.dart';
import 'package:benri_app/models/families/family_members.dart';
import 'package:benri_app/services/user_local.dart';
import 'package:benri_app/utils/constants/constant.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class FamilyService {
  static List<FamilyMember> familyMembers = [];
  static Map<String, List<FamilyIngredient>> familyShoppingListData = {};
  static final storage = FlutterSecureStorage();
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

        await storage.write(key: 'familyId', value: metadata['family_id']);
        await storage.write(key: 'family_code', value: metadata['code']);
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

        await storage.write(key: 'family_id', value: metadata['family_id']);
        await storage.write(key: 'family_code', value: metadata['code']);
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
        await storage.write(key: 'family_code', value: metadata['code']);

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

  static Future<void> getFamilyShoppingLists() async {
    try {
      final Map<String, String> userLocal = await UserLocal.getUserInfo();

      final response = await http.get(
        Uri.parse('$baseUrl/family/shopping-lists'),
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
          final listDate = list['name'] as String;
          final ingredients = (list['ingredients'] as List).map((ingredient) {
            return FamilyIngredient(
              name: ingredient['name'] ?? '',
              quantity: (ingredient['quantity'] ?? 0).toDouble(),
              category: ingredient['category'] ?? '',
              unit: ingredient['unit'] ?? '',
              status: ingredient['status'] == 'pending' ? false : true,
            );
          }).toList();

          familyShoppingListData[listDate] = ingredients;
          print('13325423324324 Family shopping list: $familyShoppingListData');
        }
      }
    } catch (e) {
      print('Error getting family shopping lists: $e');
      throw Exception('Failed to get family shopping lists');
    }
  }

  static Future<void> deleteFamily() async {
    try {
      final Map<String, String> userLocal = await UserLocal.getUserInfo();
      final familyId = await storage.read(key: 'familyId');

      if (familyId == null) throw Exception('No family ID found');

      print("Deleting family with IDDDDDDDDDDD: $familyId");

      final response = await http.delete(
        Uri.parse('$baseUrl/family/$familyId'),
        headers: {
          'x-api-key': Constants.apiKey,
          'x-client-id': userLocal['userId'] ?? '',
          'x-rtoken-id': userLocal['refreshToken'] ?? '',
          'content-type': 'application/json'
        },
      );
      print("Delete service doneeeeeeeeeeeeeeee");

      if (response.statusCode == 200) {
        await storage.delete(key: 'familyId');
        await storage.delete(key: 'family_code');
      } else {
        throw Exception('Failed to delete family');
      }
    } catch (e) {
      throw Exception('Error deleting family: $e');
    }
  }

  static Future<String?> getFamilyCode() async {
    try {
      final familyCode = await storage.read(key: 'family_code');
      return familyCode;
    } catch (e) {
      print('Error getting family code: $e');
      return null;
    }
  }
}
