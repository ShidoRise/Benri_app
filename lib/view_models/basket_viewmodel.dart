import 'dart:async';

import 'package:benri_app/models/baskets/baskets.dart';
import 'package:benri_app/models/families/family_ingredients.dart';
import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/models/ingredients/basket_ingredients.dart';
import 'package:benri_app/services/auth_service.dart';
import 'package:benri_app/services/baskets_service.dart';
import 'package:benri_app/services/family_service.dart';
import 'package:benri_app/services/ingredient_suggestions_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BasketViewModel extends ChangeNotifier {
  final DateFormat _dateFormat = DateFormat('yMd');
  DateTime _focusDate = DateTime.now();

  final TextEditingController totalMoneyController = TextEditingController();

  String _selectedMode = 'Cá nhân';
  String get selectedMode => _selectedMode;

  bool _hasFamily = false;
  bool get hasFamily => _hasFamily;

  String? _userRole;
  String? get userRole => _userRole;

  String? _familyCode;
  String? get familyCode => _familyCode;

  bool? _isLoggedIn;
  bool? get isLoggedIn => _isLoggedIn;

  String get focusDateFormatted => _dateFormat.format(_focusDate);
  DateTime get focusDate => _focusDate;

  final List<String> _unitOptions = ['gam', 'kg', 'hộp', 'quả', 'lít'];
  List<String> get unitOptions => _unitOptions;

  final List<String> _categories = [
    'Thịt & Hải sản',
    'Rau củ & Trái cây',
    'Đồ khô',
    'Đồ uống',
    'Gia vị',
    'Khác',
  ];
  List<String> get categories => _categories;

  String? _selectedUnit;
  String? get selectedUnit => _selectedUnit;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  bool _hasInternet = false;
  bool get hasInternet => _hasInternet;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<IngredientSuggestion> filteredIngredientSuggestions = [];

  BasketViewModel() {
    initConnectivity();
    _setupConnectivityStream();
    _initializeData();
    checkIsLoggedIn();
    initializeFamilyStatus();
  }

  void updateSelectedUnit(String? unit) {
    _selectedUnit = unit;
    notifyListeners();
  }

  void updateSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void resetSelections() {
    _selectedUnit = null;
    _selectedCategory = null;
    notifyListeners();
  }

  void _initializeData() {
    BasketService.initializeLocalData();
    IngredientSuggestionsService.initializeLocalData();
    notifyListeners();
  }

  void updateFocusDate(DateTime date) {
    _focusDate = date;
    BasketService.initializeBasketsForDate(focusDateFormatted);
    notifyListeners();
  }

  void addIngredient(BasketIngredient ingredient) {
    resetSelections();
    BasketService.addIngredient(focusDateFormatted, ingredient);
    notifyListeners();
    IngredientSuggestionsService.addNewIngredientSuggestion(ingredient.name);
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

  void addIngredientToFridge(
      BuildContext context, BasketIngredient ingredient) {
    BasketService.addIngredientToFridge(context, ingredient);
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
      filteredIngredientSuggestions = IngredientSuggestionsService
          .ingredientSuggestions
          .where((ingredient) => ingredient.nameInVietnamese
              .toLowerCase()
              .contains(query.toLowerCase()))
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
      final ingredient =
          IngredientSuggestionsService.ingredientSuggestions.firstWhere(
        (i) => i.nameInVietnamese.toLowerCase() == ingredientName.toLowerCase(),
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
    notifyListeners();
    await FamilyService.createFamily(famName);
    _userRole = await AuthService.storage.read(key: 'familyRole');
    print('User role: $_userRole');
    _hasFamily = true;
    _familyCode = await FamilyService.getFamilyCode();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> joinFamily(String familyCode) async {
    print('Joining family with code: $familyCode');
    _isLoading = true;
    notifyListeners();
    await FamilyService.joinFamily(familyCode);
    final familyId = await AuthService.storage.read(key: 'familyId');
    await FamilyService.getFamily(familyId!);
    await FamilyService.getFamilyShoppingLists();
    _userRole = await AuthService.storage.read(key: 'familyRole');
    _hasFamily = true;
    _familyCode = familyCode;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteFamily() async {
    _isLoading = true;
    notifyListeners();
    await FamilyService.deleteFamily();
    _hasFamily = false;
    _familyCode = null;
    _userRole = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> leaveFamily() async {
    _isLoading = true;
    notifyListeners();
    await FamilyService.leaveFamily();
    _hasFamily = false;
    _familyCode = null;
    _userRole = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> initializeFamilyStatus() async {
    try {
      _isLoading = true;
      notifyListeners();

      final familyId = await AuthService.storage.read(key: 'familyId');
      _hasFamily = familyId != null && familyId.isNotEmpty;
      print('Family ID: $familyId');

      if (_hasFamily) {
        await FamilyService.getFamily(familyId!);
        await FamilyService.getFamilyShoppingLists();
        await loadFamilyCode();
        await checkUserRole();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _hasFamily = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetFamilyStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      _hasFamily = false;
      _familyCode = null;
      _userRole = null;

      FamilyService.familyShoppingListData.clear();
      FamilyService.familyMembers.clear();
    } catch (e) {
      print('Error resetting family status: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addFamilyIngredient(FamilyIngredient ingredient) async {
    resetSelections();
    await FamilyService.addFamilyIngredient(focusDateFormatted, ingredient);
    notifyListeners();
    await IngredientSuggestionsService.addNewIngredientSuggestion(
        ingredient.name);
  }

  void deleteFamilytItem(int index) {
    FamilyService.deleteFamilyItem(focusDateFormatted, index);
    notifyListeners();
  }

  Future<void> editFamilyItem(BuildContext context, int index) async {
    await FamilyService.editFamilyItem(context, focusDateFormatted, index);
    notifyListeners();
  }

  void addFamilyIngredientToFridge(
      BuildContext context, FamilyIngredient ingredient) {
    FamilyService.addFamilyIngredientToFridge(context, ingredient);
    notifyListeners();
  }

  bool checkFamilyIngredientsEmpty(String date) {
    return FamilyService.familyShoppingListData.containsKey(date) &&
        FamilyService.familyShoppingListData[date]!.ingredients.isNotEmpty;
  }

  void toggleFamilyIngredientSelection(int index) async {
    FamilyService.toggleFamilyIngredientSelection(focusDateFormatted, index);
    notifyListeners();
  }

  String familyMemberBuyIngredients(String date) {
    if (FamilyService.familyShoppingListData.containsKey(date)) {
      for (var member in FamilyService.familyMembers) {
        if (member.id == FamilyService.familyShoppingListData[date]!.userId) {
          return member.name;
        }
      }
    }
    return '';
  }

  Future<void> showMemberBuyIngredients(
      BuildContext context, String date) async {
    await FamilyService.chooseFamilyMemberBuyIngredients(context, date);
    notifyListeners();
  }

  Future<void> loadFamilyCode() async {
    _familyCode = await FamilyService.getFamilyCode();
    notifyListeners();
  }

  Future<void> checkUserRole() async {
    _userRole = await AuthService.storage.read(key: 'familyRole') ?? '';
    print('User roleeeeeeeeeee: $_userRole');
    notifyListeners();
  }

  Future<void> checkIsLoggedIn() async {
    _isLoggedIn = await AuthService.isUserLoggedIn();
    print('Is logged in: $_isLoggedIn');
    notifyListeners();
  }

  @override
  void dispose() {
    totalMoneyController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
