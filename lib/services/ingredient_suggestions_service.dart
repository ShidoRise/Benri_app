// import 'dart:convert';
//
// import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:http/http.dart' as http;
//
// class IngredientSuggestionsService {
//   static List<IngredientSuggestion> ingredientSuggestions = [];
//   final _ingredientSuggestionsBox =
//       Hive.box<IngredientSuggestion>('ingredientSuggestionsBox');
//
//   static Future<void> initializeLocalData() async {}
//
//   Future<void> _fetchIngredientsFromApi() async {
//     final response =
//         await http.get(Uri.parse('http://54.251.104.133/v1/api/ingredients'));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body)['metadata'];
//       for (Map<String, dynamic> element in data) {
//         ingredientSuggestions.add(
//           IngredientSuggestion(
//               name: element['ingredient_name'],
//               thumbnailUrl: element['ingredient_thumbnail'],
//               nameInVietnamese: element['ingredient_name_vi']),
//         );
//       }
//       _updateLocalDatabase();
//     } else {
//       throw Exception('Failed to load ingredients from API');
//     }
//   }
//
//   Future<void> _loadDatabase() async {}
//
//   Future<void> _updateLocalDatabase() async {
//     ingredientSuggestions.forEach((ingredientSuggestion) {
//       _ingredientSuggestionsBox.put('INGREDIENTSLIST', ingredientSuggestion);
//     });
//   }
// }
