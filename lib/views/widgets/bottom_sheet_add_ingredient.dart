// ignore_for_file: unused_local_variable
import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/view_models/ingredient_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../utils/constants/colors.dart';

Future<FridgeIngredient?> addFridgeIngredientDialog(BuildContext context,
    {FridgeIngredient? fridgeIngredient}) {
  final ingredientProvider =
      Provider.of<IngredientProvider>(context, listen: false);

  if (fridgeIngredient == null) {
    ingredientProvider.clearExpirationDate(); // Clear for new ingredient
  } else {
    ingredientProvider
        .initializeExpirationDate(fridgeIngredient.expirationDate);
  }

  bool isInitialized = false;

  String? selectedIngredient;
  String? selectedUnit;
  DateTime? expirationDate;

  final TextEditingController ingredientController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController expirationDateController =
      TextEditingController();
  final TextEditingController unitController = TextEditingController();

  bool ingredientError = false;
  bool quantityError = false;
  bool expirationDateError = false;

  if (fridgeIngredient != null) {
    ingredientController.text = fridgeIngredient.name;
    quantityController.text = fridgeIngredient.quantity
        .split(' ')[0]; // Assuming the format is "amount unit"
    unitController.text =
        fridgeIngredient.quantity.split(' ')[1]; // Get the unit
    expirationDateController.text =
        DateFormat('yyyy-MM-dd').format(fridgeIngredient.expirationDate!);
  }

  void setUnits(String unit, StateSetter setState) {
    setState(() {
      selectedUnit = unit;
      unitController.text = unit;
    });
  }

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom, // Adjust for keyboard
              left: 16.0,
              right: 16.0,
              top: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thêm nguyên liệu",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),

                Autocomplete<IngredientSuggestion>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    ingredientProvider
                        .filterIngredientSuggestions(textEditingValue.text);
                    return ingredientProvider.filteredIngredientSuggestions;
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode fieldFocusNode,
                      VoidCallback onFieldSubmitted) {
                    if (!isInitialized) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        fieldTextEditingController.text =
                            ingredientController.text;
                      });
                      isInitialized = true;
                    }
                    fieldTextEditingController.text = ingredientController.text;
                    return TextFormField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: 'Tên nguyên liệu',
                        labelStyle: TextStyle(
                            color: ingredientError ? Colors.red : Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: BColors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: BColors.black),
                        ),
                      ),
                      onChanged: (value) {
                        ingredientController.text = value;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ingredientProvider.filterIngredientSuggestions(value);
                        });
                      },
                    );
                  },
                  displayStringForOption: (IngredientSuggestion option) =>
                      option.name,
                  onSelected: (IngredientSuggestion option) =>
                      ingredientController.text = option.name,
                ),

                const SizedBox(height: 20), // Space between inputs
                // TextField for quantity input
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: quantityController,
                        decoration: InputDecoration(
                          labelText: 'Số lượng',
                          labelStyle: TextStyle(
                            color: quantityError
                                ? Colors.red
                                : Colors.black, // Red label on error
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: quantityError
                                  ? Colors.red
                                  : Colors.grey, // Red border on error
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: quantityError
                                  ? Colors.red
                                  : Colors.grey, // Red focused border on error
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: unitController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Đơn vị',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BColors.primaryFirst,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setUnits('kg', setState);
                        },
                        child: const Text(
                          'kg',
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BColors.primaryFirst,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setUnits('gam', setState);
                        },
                        child: const Text(
                          'gam',
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BColors.primaryFirst,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setUnits('hộp', setState);
                        },
                        child: const Text(
                          'hộp',
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BColors.primaryFirst,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setUnits('lít', setState);
                        },
                        child: const Text(
                          'lít',
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BColors.primaryFirst,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setUnits('quả', setState);
                        },
                        child: const Text(
                          'quả',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                // TextField for expiration date

                Consumer<IngredientProvider>(
                  builder: (context, ingredientProvider, child) {
                    expirationDateController.text =
                        ingredientProvider.expirationDate != null
                            ? DateFormat('yyyy-MM-dd')
                                .format(ingredientProvider.expirationDate!)
                            : '';
                    return TextField(
                      controller: expirationDateController,
                      decoration: InputDecoration(
                        labelText: 'Chọn ngày hết hạn',
                        labelStyle: TextStyle(
                          color: expirationDateError
                              ? Colors.red
                              : Colors.black, // Red label on error
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: expirationDateError
                                ? Colors.red
                                : Colors.grey, // Red border on error
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: expirationDateError
                                ? Colors.red
                                : Colors.grey, // Red focused border on error
                          ),
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true, // Ensures it only triggers DatePicker
                      onTap: () => ingredientProvider.setExpirationDate,
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BColors.primaryFirst,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 36.0),
                      ),
                      onPressed: () => ingredientProvider.setExpirationDays(3),
                      child: const Text(
                        '3 days',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BColors.primaryFirst,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 36.0),
                      ),
                      onPressed: () => ingredientProvider.setExpirationDays(7),
                      child: const Text(
                        '7 days',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BColors.primaryFirst,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 36.0),
                      ),
                      onPressed: () => ingredientProvider.setExpirationDays(15),
                      child: const Text(
                        '15 days',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
                // Add Ingredient button
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: BColors.primaryFirst),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: BColors.primaryFirst),
                        onPressed: () {
                          setState(() {
                            ingredientError = ingredientController.text.isEmpty;

                            quantityError = quantityController.text.isEmpty;

                            expirationDateError =
                                expirationDateController.text.isEmpty;
                          });

                          // Only proceed if all fields are valid (no errors)
                          if (!ingredientError &&
                              !quantityError &&
                              !expirationDateError) {
                            final ingredientToSave = ingredientController.text;

                            final unitToSave = unitController.text.isNotEmpty
                                ? unitController.text
                                : selectedUnit ?? "";
                            final imageUrl = ingredientProvider
                                .getImageUrlFromLocalStorage(ingredientToSave);

                            final newIngredient = FridgeIngredient(
                              name: ingredientToSave,
                              quantity:
                                  '${quantityController.text} $unitToSave',
                              imgPath: imageUrl,
                              expirationDate:
                                  ingredientProvider.expirationDate!,
                            );

                            // Return the new ingredient to the previous screen
                            Navigator.of(context).pop(newIngredient);
                          }
                        },
                        child: Text(
                          fridgeIngredient != null
                              ? 'Cập nhật nguyên liệu'
                              : 'Thêm nguyên liệu',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
