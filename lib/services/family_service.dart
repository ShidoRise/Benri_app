import 'package:benri_app/services/user_local.dart';
import 'package:benri_app/utils/constants/constant.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class FamilyService {
  static final storage = FlutterSecureStorage();
  static final String baseUrl = dotenv.get('API_URL');

  FamilyService._();

  static Future<Map<String, dynamic>> createFamily(String famName) async {
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

      print("222222222222222 ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("333333333333333 $responseData");

        final metadata = responseData['metadata'];

        await storage.write(key: 'family_id', value: metadata['family_id']);
        await storage.write(key: 'family_code', value: metadata['code']);

        return responseData;
      } else {
        throw Exception('Failed to create family: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating family: $e');
    }
  }

  static Future<Map<String, dynamic>> joinFamily(String famCode) async {
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

      print("222222222222222 ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("333333333333333 $responseData");

        final metadata = responseData['metadata'];

        await storage.write(key: 'family_id', value: metadata['family_id']);
        await storage.write(key: 'family_code', value: metadata['code']);

        return responseData;
      } else {
        throw Exception('Failed to join family: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error joining family: $e');
    }
  }

  static Future<Map<String, dynamic>> getFamily() async {
    try {
      final Map<String, String> userLocal = await UserLocal.getUserInfo();

      final response = await http.get(
        Uri.parse('$baseUrl/family'),
        headers: {
          'x-api-key': Constants.apiKey,
          'x-client-id': userLocal['userId'] ?? '',
          'x-rtoken-id': userLocal['refreshToken'] ?? '',
        },
      );

      print("222222222222222 ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("333333333333333 $responseData");

        final metadata = responseData['metadata'];

        await storage.write(key: 'family_code', value: metadata['code']);

        return responseData;
      } else {
        throw Exception('Failed to get family: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting family: $e');
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
