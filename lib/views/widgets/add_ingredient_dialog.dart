import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
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

  final List<String> ingredientCategories = [
    'Thịt',
    'Hải sản',
    'Rau cải',
    'Trái cây',
    'Đồ uống',
    'Đồ khô',
    'Đồ ăn chay',
    'Đồ ăn nhanh',
    'Đồ ăn sáng',
    'Đồ ăn vặt',
    'Đồ ăn chính',
    'Đồ ăn phụ',
    'Đồ ăn tráng miệng',
    'Đồ ăn khác',
  ];

  bool isInitialized = false;

  return showModalBottomSheet<BasketIngredient>(
    context: context,
    isScrollControlled: true,
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
                        decoration: InputDecoration(
                          labelText: 'Tên nguyên liệu',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: quantityInputController,
                    cursorColor: Theme.of(context).colorScheme.primary,
                    decoration: InputDecoration(
                      labelText: 'Số lượng',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: unitInputController,
                    cursorColor: Theme.of(context).colorScheme.primary,
                    decoration: InputDecoration(
                      labelText: 'Đơn vị',
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
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
                  const SizedBox(height: 10),
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
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            selected: basketViewModel.selectedUnit == unit,
                            onSelected: (bool selected) {
                              basketViewModel
                                  .updateSelectedUnit(selected ? unit : null);
                              unitInputController.text =
                                  basketViewModel.selectedUnit ?? '';
                            },
                            selectedColor:
                                Theme.of(context).colorScheme.primary,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Phân loại:'),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: ingredientCategories.map((category) {
                      return Consumer<BasketViewModel>(
                        builder: (context, basketViewModel, child) {
                          return ChoiceChip(
                            label: Text(category),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            selected:
                                basketViewModel.selectedCategory == category,
                            onSelected: (bool selected) {
                              basketViewModel.updateSelectedCategory(
                                  selected ? category : null);
                            },
                          );
                        },
                      );
                    }).toList(),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      final updatedIngredient = BasketIngredient(
                        name: nameInputController.text,
                        quantity: quantityInputController.text,
                        unit: unitInputController.text,
                        imageUrl: basketViewModel.getImageUrlFromLocalStorage(
                            nameInputController.text),
                        category: basketViewModel.selectedCategory ?? 'Khác',
                      );
                      Navigator.pop(context, updatedIngredient);
                    },
                    child: Text(
                      'Thêm',
                      style: TextStyle(
                        fontSize: 15,
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
