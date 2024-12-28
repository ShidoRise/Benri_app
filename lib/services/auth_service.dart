import 'package:benri_app/services/firebase_msg_service.dart';
import 'package:benri_app/services/user_local.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:benri_app/utils/constants/constant.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  AuthService._();
  static final storage = FlutterSecureStorage();
  static final String baseUrl = dotenv.get('API_URL');
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<User?> signInWithGoogle() async {
    try {
      print('1==');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Người dùng đã hủy đăng nhập
        print('User canceled the login');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('2==');

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('3==');

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      print('4==');

      // Gửi token đến backend để xác thực và tạo người dùng
      final response = await http.post(
        Uri.parse('$baseUrl/google-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': googleAuth.idToken}),
      );
      print('5== ${response.body}');
      if (response.statusCode == 200) {
        // Xử lý đăng nhập thành công
        print('Login successful');
        final responseData = jsonDecode(response.body)['metadata'];
        final user = responseData['user'];
        final tokens = responseData['tokens'];
        final email = user['user_email'];
        final userId = user['_id'];
        final name = user['user_name'];

        if (user['user_family_group'] != null) {
          final family = user['user_family_group'];
          final role = user['user_role_group']['role'];
          await storage.write(key: 'familyId', value: family);
          await storage.write(key: 'familyRole', value: role);
        } else {
          await storage.delete(key: 'familyId');
          await storage.write(key: 'familyId', value: null);
          await storage.delete(key: 'familyRole');
          await storage.write(key: 'familyRole', value: null);
        }
        await storage.write(key: 'isGG', value: 'true');

        await _saveUserData(
            userId, tokens['refreshToken'], tokens['accessToken'], email, name);
        await FirebaseMsg.saveTokenToDatabase(userId);
        return userCredential.user;
      } else {
        // Xử lý lỗi đăng nhập
        print('Failed to login with Google: ${response.body}');
        throw Exception('Failed to login with Google');
      }
    } catch (e) {
      print('Error during Google sign-in: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {
              'x-api-key': Constants.apiKey,
              'content-type': 'application/json'
            },
            body: jsonEncode({
              "email": email,
              "password": password,
            }),
          )
          .timeout(
            Duration(seconds: 4),
          );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['metadata'];
        final user = responseData['user'];
        final tokens = responseData['tokens'];
        final email = user['user_email'];
        final userId = user['_id'];
        final name = user['user_name'];

        if (user['user_family_group'] != null) {
          final family = user['user_family_group'];
          final role = user['user_role_group']['role'];
          await storage.write(key: 'familyId', value: family);
          await storage.write(key: 'familyRole', value: role);
        } else {
          await storage.delete(key: 'familyId');
          await storage.write(key: 'familyId', value: null);
          await storage.delete(key: 'familyRole');
          await storage.write(key: 'familyRole', value: null);
        }

        await _saveUserData(
            userId, tokens['refreshToken'], tokens['accessToken'], email, name);
        await FirebaseMsg.saveTokenToDatabase(userId);
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  static Future<bool> preSignUp(
      String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pre_signup'),
        headers: {
          'x-api-key': Constants.apiKey,
          'content-type': 'application/json'
        },
        body: jsonEncode({"email": email, "password": password, "name": name}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('signup error: $e');
      return false;
    }
  }

  static Future<bool> verifyOTP(
      String email, String password, String name, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify_otp_and_signup'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': Constants.apiKey,
        },
        body: jsonEncode({
          "email": email,
          "password": password,
          "name": name,
          "otp": otp,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['metadata'];
        print('response dki:::::::::::::' + responseData.toString());
        final user = responseData['user'];
        final tokens = responseData['tokens'];
        final email = user['user_email'];

        if (user['user_family_group'] != null) {
          final family = user['user_family_group'];
          final role = user['user_role_group']['role'];
          await storage.write(key: 'familyId', value: family);
          await storage.write(key: 'familyRole', value: role);
        } else {
          await storage.delete(key: 'familyId');
          await storage.write(key: 'familyId', value: null);
          await storage.delete(key: 'familyRole');
          await storage.write(key: 'familyRole', value: null);
        }

        await _saveUserData(user['_id'], tokens['refreshToken'],
            tokens['accessToken'], email, user['user_name']);
        return true;
      } else {
        print('Error verifying OTP: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    }
  }

  static Future<void> _saveUserData(String userId, String refreshToken,
      String accessToken, String email, String name) async {
    try {
      await storage.write(key: 'userId', value: userId);
      await storage.write(key: 'refreshToken', value: refreshToken);
      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'name', value: name);
      printData();
    } catch (e) {
      print('Failed to save user data: $e');
    }
  }

  static Future<Map<String, String?>> printData() async {
    try {
      String? userId = await storage.read(key: 'userId');
      String? refreshToken = await storage.read(key: 'refreshToken');
      String? accessToken = await storage.read(key: 'accessToken');
      String? email = await storage.read(key: 'email');

      return {
        'userId': userId,
        'refreshToken': refreshToken,
        'accessToken': accessToken,
        'email': email,
      };
    } catch (e) {
      print('Failed to retrieve user data: $e');
      return {};
    }
  }

  static Future<bool> changePassword(oldPass, newPass) async {
    final Map<String, String> userLocal = await UserLocal.getUserInfo();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/change_password'),
        headers: {
          'x-api-key': Constants.apiKey,
          'authorization': userLocal['accessToken'] ?? '',
          'x-client-id': userLocal['userId'] ?? '',
          'content-type': 'application/json'
        },
        body: jsonEncode({"oldPassword": oldPass, "newPassword": newPass}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> resendOTP(String email, String name) async {
    final Map<String, String> userLocal = await UserLocal.getUserInfo();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/resend-otp'),
        headers: {
          'x-api-key': Constants.apiKey,
          'authorization': userLocal['accessToken'] ?? '',
          'x-client-id': userLocal['userId'] ?? '',
          'content-type': 'application/json'
        },
        body: jsonEncode({"email": email, "name": name}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> forgotPassword(String email) async {
    try {
      final Map<String, String> userLocal = await UserLocal.getUserInfo();
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/request_reset_password'),
          headers: {
            'x-api-key': Constants.apiKey,
            'content-type': 'application/json'
          },
          body: jsonEncode({"email": email, "name": 'Bạn'}),
        );
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print(e);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> xacthucReset(String email, String otp) async {
    try {
      final Map<String, String> userLocal = await UserLocal.getUserInfo();
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/reset_password'),
          headers: {
            'x-api-key': Constants.apiKey,
            'content-type': 'application/json'
          },
          body: jsonEncode({"email": email, "otp": otp}),
        );
        print(response);
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print(e);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isUserLoggedIn() async {
    String? userId = await storage.read(key: 'userId');
    return userId != null;
  }
}
