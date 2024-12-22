import 'dart:async';

import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/models/ingredients/basket_ingredients.dart';
import 'package:benri_app/services/baskets_service.dart';
import 'package:benri_app/services/family_service.dart';
import 'package:benri_app/utils/constants/ingredient_suggestions_db.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class BasketViewModel extends ChangeNotifier {
  final _ingredientSuggestionsBox = Hive.box('ingredientSuggestionsBox');

  IngredientSuggestionsDB ingredientsDB = IngredientSuggestionsDB();

  List<IngredientSuggestion> filteredIngredientSuggestions = [];

  final DateFormat _dateFormat = DateFormat('yMd');
  DateTime _focusDate = DateTime.now();

  final TextEditingController totalMoneyController = TextEditingController();

  String _selectedMode = 'Cá nhân';
  String get selectedMode => _selectedMode;

  bool _hasFamily = false;
  bool get hasFamily => _hasFamily;
  bool _isInitialized = false;

  String? _familyCode;
  String? get familyCode => _familyCode;

  String get focusDateFormatted => _dateFormat.format(_focusDate);
  DateTime get focusDate => _focusDate;

  String? _selectedUnit;
  String? get selectedUnit => _selectedUnit;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  bool _hasInternet = false;
  bool get hasInternet => _hasInternet;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  BasketViewModel() {
    initConnectivity();
    _setupConnectivityStream();
    _initializeData();
  }

  void updateSelectedUnit(String? unit) {
    _selectedUnit = unit;
    notifyListeners();
  }

  void updateSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void _initializeData() {
    BasketService.initializeLocalData();
    if (_ingredientSuggestionsBox.get('isFirstTime') == null) {
      ingredientsDB.createInitialData();
      _ingredientSuggestionsBox.put('isFirstTime', false);
      notifyListeners();
    } else {
      ingredientsDB.loadData();
    }
    notifyListeners();
  }

  void updateFocusDate(DateTime date) {
    _focusDate = date;
    BasketService.initializeBasketsForDate(focusDateFormatted);
    notifyListeners();
  }

  void addIngredient(BasketIngredient ingredient) {
    BasketService.addIngredient(focusDateFormatted, ingredient);
    notifyListeners();
  }

  void toggleIngredientSelection(int index) {
    BasketService.toggleIngredientSelection(focusDateFormatted, index);
    notifyListeners();
  }

  void deleteBasketItem(int index) {
    BasketService.deleteBasketItem(focusDateFormatted, index);
    notifyListeners();
  }

  void editBasketItem(BuildContext context, int index) {
    BasketService.editBasketItem(context, focusDateFormatted, index);
    notifyListeners();
  }

  void updateCalendarFocusDate(DateTime date, DateTime focusDate) {
    _focusDate = date;
    notifyListeners();
  }

  String formatDateTimeToString(DateTime date) {
    return _dateFormat.format(date);
  }

  void filterIngredientSuggestions(String query) {
    if (query.isNotEmpty) {
      filteredIngredientSuggestions = ingredientsDB.ingredientSuggestions
          .where((ingredient) =>
              ingredient.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      filteredIngredientSuggestions = [];
    }
    notifyListeners();
  }

  void clearIngredientSuggestions() {
    filteredIngredientSuggestions = [];
    notifyListeners();
  }

  String getImageUrlFromLocalStorage(String ingredientName) {
    if (ingredientName.isNotEmpty) {
      final ingredient = ingredientsDB.ingredientSuggestions.firstWhere(
        (i) => i.name.toLowerCase() == ingredientName.toLowerCase(),
        orElse: () => IngredientSuggestion(
            name: '', thumbnailUrl: '', nameInVietnamese: ''),
      );
      return ingredient.thumbnailUrl;
    }
    return '';
  }

  bool checkBasketIngredientsEmpty(String date) {
    return BasketService.baskets.containsKey(date) &&
        BasketService.baskets[date]!.basketIngredients.isNotEmpty;
  }

  void updateTotalMoney(String totalMoney) {
    BasketService.updateTotalMoney(focusDateFormatted, totalMoney);
    notifyListeners();
  }

  String getTotalMoney() {
    if (BasketService.baskets.containsKey(focusDateFormatted)) {
      return BasketService.baskets[focusDateFormatted]!.totalMoney;
    }
    return '0';
  }

  void changeMode(String mode) {
    _selectedMode = mode;
    notifyListeners();
  }

  Future<void> initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectionStatus(result != ConnectivityResult.none);
    } catch (e) {
      _updateConnectionStatus(false);
    }
  }

  void _setupConnectivityStream() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result != ConnectivityResult.none);
    });
  }

  void _updateConnectionStatus(bool isConnected) {
    _hasInternet = isConnected;
    notifyListeners();
  }

  Future<void> createFamily(String famName) async {
    _isLoading = true;
    await FamilyService.createFamily(famName);
    _hasFamily = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> initializeFamilyStatus() async {
    if (_isInitialized) return;

    try {
      final familyId = await FamilyService.storage.read(key: 'familyId');
      _hasFamily = familyId != null && familyId.isNotEmpty;
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error initializing family status: $e');
      _hasFamily = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  void checkFamilyStatus() {
    if (!_isInitialized) {
      initializeFamilyStatus();
    }
  }

  Future<void> loadFamilyCode() async {
    _familyCode = await FamilyService.getFamilyCode();
    notifyListeners();
  }

  @override
  void dispose() {
    totalMoneyController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
