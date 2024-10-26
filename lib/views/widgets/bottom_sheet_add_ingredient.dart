// ignore_for_file: unused_local_variable
import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/constants/colors.dart';


Future<FridgeIngredient?> addIngredientDialog(BuildContext context) {

  final List<String> ingredients = [
    'Apple',
    'Banana',
    'Tomato',
    'Onion',
    'Potato',
    'Egg',
    'Pork Belly',
    'Chicken Breast',
    'Salmon',
    'Beef'
  ];

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

  // Helper method to show DatePicker
  Future<void> selectExpirationDate(
      BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != expirationDate) {
      setState(() {
        expirationDate = picked;
        expirationDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void setExpirationDays(int days, StateSetter setState) {
    final DateTime newDate = DateTime.now().add(Duration(days: days));
    setState(() {
      expirationDate = newDate;
      expirationDateController.text = DateFormat('yyyy-MM-dd').format(newDate);
    });
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
                  "Add Ingredient",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Autocomplete for ingredient selection, or allow free text input
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    // If user hasn't typed anything, return empty list
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    // Filter ingredients based on user input
                    return ingredients.where((String ingredient) {
                      return ingredient
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    setState(() {
                      selectedIngredient = selection;
                      ingredientController.text =
                          selection; // Autofill the text field with selected suggestion
                    });
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      onChanged: (text) {
                        setState(() {
                          selectedIngredient = text;
                          ingredientController.text =
                              text; // Store free text input as the selected ingredient
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Ingredient Name',
                        labelStyle: TextStyle(
                          color: ingredientError
                              ? Colors.red
                              : Colors.black, // Red label on error
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: ingredientError
                                ? Colors.red
                                : Colors.grey, // Red border on error
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: ingredientError
                                ? Colors.red
                                : BColors.grey, // Red focused border on error
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20), // Space between inputs
                // TextField for quantity input
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: quantityController,
                        decoration: InputDecoration(
                          labelText: 'Enter Quantity',
                          labelStyle: TextStyle(
                            color: quantityError
                                ? Colors.red
                                : Colors.black, // Red label on error
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: quantityError
                                  ? Colors.red
                                  : Colors.grey, // Red border on error
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
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
                          labelText: 'Units',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
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
                          backgroundColor: BColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setUnits('kg', setState);
                        },
                        child: const Text('kg')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setUnits('g', setState);
                        },
                        child: const Text('g')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setUnits('Box', setState);
                        },
                        child: const Text('Box')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setUnits('Lit', setState);
                        },
                        child: const Text('Lit')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setUnits('Bunch', setState);
                        },
                        child: const Text('Bunch')),
                  ],
                ),
                const SizedBox(height: 20),
                // TextField for expiration date
                TextField(
                  controller: expirationDateController,
                  decoration: InputDecoration(
                    labelText: 'Enter Expiration Date',
                    labelStyle: TextStyle(
                      color: expirationDateError
                          ? Colors.red
                          : Colors.black, // Red label on error
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: expirationDateError
                            ? Colors.red
                            : Colors.grey, // Red border on error
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: expirationDateError
                            ? Colors.red
                            : Colors.grey, // Red focused border on error
                      ),
                    ),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true, // Ensures it only triggers DatePicker
                  onTap: () => selectExpirationDate(context, setState),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 36.0),
                      ),
                      onPressed: () => setExpirationDays(3, setState),
                      child: const Text('3 days'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 36.0),
                      ),
                      onPressed: () => setExpirationDays(7, setState),
                      child: const Text('7 days'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 36.0),
                      ),
                      onPressed: () => setExpirationDays(15, setState),
                      child: const Text('15 days'),
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
                            backgroundColor: BColors.accent),
                        child: Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: BColors.accent),
                        onPressed: () {
                          setState(() {
                            // Check if ingredient field is empty
                            ingredientError = ingredientController.text.isEmpty;


                            // Check if quantity field is empty
                            quantityError = quantityController.text.isEmpty;

                        final unitToSave = unitController.text.isNotEmpty
                            ? unitController.text
                            : selectedUnit ?? "";
                        // Create a new Ingredient object
                        final newIngredient = FridgeIngredient(
                          name: ingredientToSave, // Allow custom ingredient
                          quantity: '${quantityController.text} $unitToSave',
                          imgPath: ingredients
                                  .contains(ingredientController.text)
                              ? 'assets/images/ingredient/${ingredientController.text}.png'
                              : 'assets/images/ingredient/.png', // Add the appropriate path
                          expirationDate: expirationDate!,
                        );

                            // Check if expiration date is not selected
                            expirationDateError = expirationDate == null;
                          });

                          // Only proceed if all fields are valid (no errors)
                          if (!ingredientError &&
                              !quantityError &&
                              !expirationDateError) {
                            final ingredientToSave =
                                selectedIngredient ?? ingredientController.text;

                            final unitToSave = unitController.text.isNotEmpty
                                ? unitController.text
                                : selectedUnit ?? "";

                            final newIngredient = FridgeIngredient(
                              name: ingredientToSave,
                              quantity:
                                  '${quantityController.text} $unitToSave',
                              imgPath: ingredients
                                      .contains(ingredientController.text)
                                  ? 'assets/images/ingredient/${ingredientController.text}.png'
                                  : 'assets/images/ingredient/default.png',
                              expirationDate: expirationDate!,
                            );

                            // Return the new ingredient to the previous screen
                            Navigator.of(context).pop(newIngredient);
                          }
                        },
                        child: const Text('Add Ingredient'),
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
