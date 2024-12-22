// ignore_for_file: unused_local_variable
import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/view_models/ingredient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants/colors.dart';

Future<FridgeIngredient?> addIngredientRecipeDialog(BuildContext context,
    {FridgeIngredient? fridgeIngredient}) {
  final ingredientProvider =
      Provider.of<IngredientProvider>(context, listen: false);

  bool isInitialized = false;

  String? selectedIngredient;
  String? selectedUnit;

  final TextEditingController ingredientController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
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
                          borderSide: BorderSide(color: BColors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: BColors.black),
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
                        keyboardType: TextInputType.number,
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
                    ChoiceChip(
                      label: const Text('gam'),
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      selected: selectedUnit == 'gam',
                      onSelected: (bool selected) {
                        setUnits('gam', setState);
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                    ),
                    ChoiceChip(
                      label: const Text('kg'),
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      selected: selectedUnit == 'kg',
                      onSelected: (bool selected) {
                        setUnits('kg', setState);
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                    ),
                    ChoiceChip(
                      label: const Text('hộp'),
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      selected: selectedUnit == 'hộp',
                      onSelected: (bool selected) {
                        setUnits('hộp', setState);
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                    ),
                    ChoiceChip(
                      label: const Text('quả'),
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      selected: selectedUnit == 'quả',
                      onSelected: (bool selected) {
                        setUnits('quả', setState);
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                    ),
                    ChoiceChip(
                      label: const Text('lít'),
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      selected: selectedUnit == 'lít',
                      onSelected: (bool selected) {
                        setUnits('lít', setState);
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // TextField for expiration date

                const SizedBox(height: 20),

                const SizedBox(height: 70),
                // Add Ingredient button
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: BColors.primaryFirst),
                          child: Text("Huỷ bỏ"),
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: BColors.primaryFirst),
                          onPressed: () {
                            setState(() {
                              ingredientError =
                                  ingredientController.text.isEmpty;

                              quantityError = quantityController.text.isEmpty;
                            });

                            // Only proceed if all fields are valid (no errors)
                            if (!ingredientError &&
                                !quantityError &&
                                !expirationDateError) {
                              final ingredientToSave =
                                  ingredientController.text;

                              final unitToSave = unitController.text.isNotEmpty
                                  ? unitController.text
                                  : selectedUnit ?? "";
                              final imageUrl = ingredientProvider
                                  .getImageUrlFromLocalStorage(
                                      ingredientToSave);

                              final newIngredient = FridgeIngredient(
                                name: ingredientToSave,
                                quantity:
                                    '${quantityController.text} $unitToSave',
                                imgPath: imageUrl,
                                expirationDate: null,
                              );

                              // Return the new ingredient to the previous screen
                              Navigator.of(context).pop(newIngredient);
                            }
                          },
                          child: Text('Thêm nguyên liệu'),
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
