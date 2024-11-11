import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benri_app/models/ingredients/basket_ingredients.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';

Future<BasketIngredient?> addIngredientDialog(BuildContext context,
    {BasketIngredient? ingredient}) {
  final TextEditingController nameInputController =
      TextEditingController(text: ingredient?.name ?? '');
  final TextEditingController quantityInputController =
      TextEditingController(text: ingredient?.quantity ?? '');
  final TextEditingController unitInputController =
      TextEditingController(text: ingredient?.unit ?? '');

  final basketViewModel = Provider.of<BasketViewModel>(context, listen: false);
  final List<String> unitOptions = ['gam', 'kg', 'hộp', 'quả', 'lít'];

  bool isInitialized = false;

  return showModalBottomSheet<BasketIngredient>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (context) {
      return ChangeNotifierProvider<BasketViewModel>.value(
        value: basketViewModel,
        child: Consumer<BasketViewModel>(
            builder: (context, basketViewModel, child) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 16.0,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Autocomplete<IngredientSuggestion>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      basketViewModel
                          .filterIngredientSuggestions(textEditingValue.text);
                      return basketViewModel.filteredIngredientSuggestions;
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                      if (!isInitialized) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          fieldTextEditingController.text =
                              nameInputController.text;
                        });
                        isInitialized = true;
                      }
                      return TextFormField(
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: 'Tên nguyên liệu',
                          labelStyle: TextStyle(color: Colors.black),
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
                          nameInputController.text = value;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            basketViewModel.filterIngredientSuggestions(value);
                          });
                        },
                      );
                    },
                    displayStringForOption: (IngredientSuggestion option) =>
                        option.name,
                    onSelected: (IngredientSuggestion option) =>
                        nameInputController.text = option.name,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: quantityInputController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: 'Số lượng',
                      labelStyle: TextStyle(color: BColors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: BColors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: BColors.black),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: unitInputController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: 'Đơn vị',
                      labelStyle: TextStyle(color: BColors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: BColors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: BColors.black),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      if (!unitOptions.contains(value)) {
                        basketViewModel.updateSelectedUnit(null);
                      } else {
                        basketViewModel.updateSelectedUnit(value);
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 20.0,
                    children: unitOptions.map((unit) {
                      return Consumer<BasketViewModel>(
                        builder: (context, basketViewModel, child) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            basketViewModel
                                .updateSelectedUnit(unitInputController.text);
                          });
                          return ChoiceChip(
                            label: Text(unit),
                            backgroundColor: BColors.accent,
                            selected: basketViewModel.selectedUnit == unit,
                            onSelected: (bool selected) {
                              basketViewModel
                                  .updateSelectedUnit(selected ? unit : null);
                              unitInputController.text =
                                  basketViewModel.selectedUnit ?? '';
                            },
                            selectedColor: BColors.primaryFirst,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: BColors.primaryFirst,
                    ),
                    onPressed: () {
                      final updatedIngredient = BasketIngredient(
                        name: nameInputController.text,
                        quantity: quantityInputController.text,
                        unit: unitInputController.text,
                        imageUrl: basketViewModel.getImageUrlFromLocalStorage(
                            nameInputController.text),
                      );
                      Navigator.pop(context, updatedIngredient);
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    },
  );
}
