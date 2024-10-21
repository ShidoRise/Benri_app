import 'package:benri_app/models/ingredients/ingredients.dart';
import 'package:benri_app/utils/constants/local_db.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class BasketViewModel extends ChangeNotifier {
  final _myBox = Hive.box('mybox');
  BasketsLocalDB db = BasketsLocalDB();

  final DateFormat _dateFormat = DateFormat('yMd');
  DateTime _focusDate = DateTime.now();

  // Constructor to initialize data
  BasketViewModel() {
    _initializeData();
  }

  String get focusDateFormatted => _dateFormat.format(_focusDate);
  DateTime get focusDate => _focusDate;

  // Initialize data when the app is first opened
  void _initializeData() {
    if (_myBox.get('isFirstTime') == null) {
      db.createInitialData();
      db.updateDatabase();
      _myBox.put('isFirstTime', false); // Mark as first time opened
      notifyListeners();
    } else {
      db.loadData();
    }
    notifyListeners();
  }

  void updateFocusDate(DateTime date) {
    _focusDate = date;
    _initializeBasketsForDate(_focusDate);
    notifyListeners();
  }

  void _initializeBasketsForDate(DateTime date) {
    String formattedDate = _dateFormat.format(date);
    if (!db.baskets.containsKey(formattedDate)) {
      db.baskets[formattedDate] = [];
    }
  }

  void addIngredient(String name) {
    _initializeBasketsForDate(_focusDate);
    db.baskets[focusDateFormatted]!.add(Ingredient(name: name));
    db.updateDatabase();
    notifyListeners();
  }

  void toggleIngredientSelection(int index) {
    if (index >= 0 && index < db.baskets[focusDateFormatted]!.length) {
      db.baskets[focusDateFormatted]![index].isSelected =
          !db.baskets[focusDateFormatted]![index].isSelected;
      db.updateDatabase();
      notifyListeners();
    }
  }

  void deleteBasketItem(int index) {
    if (index >= 0 && index < db.baskets[focusDateFormatted]!.length) {
      db.baskets[focusDateFormatted]!.removeAt(index);
      db.updateDatabase();
      notifyListeners();
    }
  }

  void updateCalendarFocusDate(DateTime date, DateTime focusDate) {
    _focusDate = date;
    notifyListeners();
  }

  String formatDateTimeToString(DateTime date) {
    return _dateFormat.format(date);
  }
}
