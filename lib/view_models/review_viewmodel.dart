import 'package:benri_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewProvider with ChangeNotifier {
  static final String baseUrl = dotenv.get('API_URL');

  Map<String, dynamic> ingredientMap = {"basket": {}, "family": {}};

  Map<String, dynamic> pendingIngredientMap = {"basket": {}, "family": {}};

  ReviewProvider() {
    fetchReviewData(DateTime.now().month.toInt(), DateTime.now().year.toInt());
  }

  Future<void> fetchReviewData(int month, int year) async {
    try {
      final data = await AuthService.fetchReviewData(month, year);
      if (data != null) {
        ingredientMap = data['ingredientMap'];
        pendingIngredientMap = data['pendingIngredientMap'];
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
