import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/ingredient_provider.dart';
import 'package:benri_app/view_models/recipe_creation_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

Future<FridgeIngredient?> addIngredientRecipeDialog(
  BuildContext context, {
  FridgeIngredient? fridgeIngredient,
}) {
  final nameController =
      TextEditingController(text: fridgeIngredient?.name ?? '');
  final quantityController =
      TextEditingController(text: fridgeIngredient?.quantity ?? '');
  final unitController =
      TextEditingController(text: fridgeIngredient?.unit ?? '');
  final provider = Provider.of<RecipeCreationProvider>(context, listen: false);

  bool isInitialized = false;

  return showModalBottomSheet<FridgeIngredient>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => ChangeNotifierProvider<RecipeCreationProvider>.value(
      value: provider,
      child: Consumer<RecipeCreationProvider>(
        builder: (context, model, _) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fridgeIngredient == null
                      ? 'Thêm nguyên liệu'
                      : 'Sửa nguyên liệu',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                _buildIngredientNameField(
                    context, nameController, model, isInitialized),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildQuantityField(context, quantityController),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: _buildUnitField(context, unitController),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildUnitChips(
                    context, model.unitOptions, model, unitController),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(width: 1),
                          backgroundColor: Colors.white,
                          elevation: 2,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child:
                            const Text('Hủy', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: BColors.primaryFirst,
                        ),
                        onPressed: () {
                          if (nameController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: 'Vui lòng nhập tên nguyên liệu');
                            return;
                          } else if (quantityController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: 'Vui lòng nhập số lượng');
                            return;
                          } else if (unitController.text.isEmpty) {
                            Fluttertoast.showToast(msg: 'Vui lòng nhập đơn vị');
                            return;
                          }

                          Navigator.pop(
                            context,
                            FridgeIngredient(
                              name: nameController.text,
                              quantity: quantityController.text,
                              unit: unitController.text,
                              expirationDate: null,
                              imgPath: '',
                            ),
                          );
                        },
                        child: Text(
                          fridgeIngredient == null ? 'Thêm' : 'Cập nhật',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildIngredientNameField(
  BuildContext context,
  TextEditingController controller,
  RecipeCreationProvider model,
  bool isInitialized,
) {
  return Autocomplete<IngredientSuggestion>(
    optionsBuilder: (TextEditingValue textEditingValue) {
      model.filterIngredientSuggestions(textEditingValue.text);
      return model.filteredIngredientSuggestions;
    },
    displayStringForOption: (IngredientSuggestion option) =>
        option.nameInVietnamese,
    onSelected: (IngredientSuggestion option) =>
        controller.text = option.nameInVietnamese,
    fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
      if (!isInitialized) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          textController.text = controller.text;
        });
        isInitialized = true;
      }
      return TextFormField(
        controller: textController,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: 'Tên nguyên liệu',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) {
          controller.text = value;
          model.filterIngredientSuggestions(value);
        },
      );
    },
  );
}

Widget _buildQuantityField(
    BuildContext context, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: 'Số lượng',
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

Widget _buildUnitField(BuildContext context, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: 'Đơn vị',
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

Widget _buildUnitChips(
  BuildContext context,
  List<String> units,
  RecipeCreationProvider model,
  TextEditingController unitController,
) {
  return Wrap(
    alignment: WrapAlignment.spaceBetween,
    spacing: 5,
    children: units.map((unit) {
      return ChoiceChip(
        label: Text(unit),
        selected: model.selectedUnit == unit,
        onSelected: (selected) {
          model.updateSelectedUnit(selected ? unit : null);
          unitController.text = selected ? unit : '';
        },
        selectedColor: BColors.accent,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(12)),
      );
    }).toList(),
  );
}
