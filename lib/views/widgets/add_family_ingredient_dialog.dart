import 'package:benri_app/models/families/family_ingredients.dart';
import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

Future<FamilyIngredient?> addFamilyIngredientDialog(
  BuildContext context,
  String functionName, {
  FamilyIngredient? ingredient,
}) {
  final nameController = TextEditingController(text: ingredient?.name ?? '');
  final quantityController = TextEditingController(
    text: ingredient?.quantity ?? '',
  );
  final unitController = TextEditingController(text: ingredient?.unit ?? '');
  final viewModel = Provider.of<BasketViewModel>(context, listen: false);

  bool isInitialized = false;

  return showModalBottomSheet<FamilyIngredient>(
    context: context,
    isScrollControlled: true,
    builder: (context) => ChangeNotifierProvider<BasketViewModel>.value(
      value: viewModel,
      child: Consumer<BasketViewModel>(
        builder: (context, model, _) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIngredientNameField(
                context,
                nameController,
                model,
                isInitialized,
              ),
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
              _buildCategoryChips(context, model.categories, model),
              const SizedBox(height: 24),
              _buildSubmitButton(
                context,
                nameController,
                quantityController,
                unitController,
                model,
                functionName,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildIngredientNameField(
  BuildContext context,
  TextEditingController controller,
  BasketViewModel model,
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
  BuildContext context,
  TextEditingController controller,
) {
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
  BasketViewModel model,
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

Widget _buildCategoryChips(
  BuildContext context,
  List<String> categories,
  BasketViewModel model,
) {
  return Wrap(
    alignment: WrapAlignment.spaceBetween,
    spacing: 5,
    runSpacing: 8,
    children: categories.map((category) {
      return ChoiceChip(
        label: Text(category),
        selected: model.selectedCategory == category,
        onSelected: (selected) {
          model.updateSelectedCategory(selected ? category : null);
        },
        selectedColor: BColors.accent,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(12)),
      );
    }).toList(),
  );
}

Widget _buildSubmitButton(
  BuildContext context,
  TextEditingController nameController,
  TextEditingController quantityController,
  TextEditingController unitController,
  BasketViewModel model,
  String functionName,
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: BColors.primaryFirst,
    ),
    onPressed: () {
      if (nameController.text.isEmpty) {
        Fluttertoast.showToast(msg: 'Vui lòng nhập tên nguyên liệu');
        return;
      } else if (quantityController.text.isEmpty) {
        Fluttertoast.showToast(msg: 'Vui lòng nhập số lượng');
        return;
      } else if (unitController.text.isEmpty) {
        Fluttertoast.showToast(msg: 'Vui lòng nhập đơn vị');
        return;
      } else if (model.selectedCategory == null) {
        Fluttertoast.showToast(msg: 'Vui lòng chọn danh mục');
        return;
      }

      final ingredient = FamilyIngredient(
        name: nameController.text.trim(),
        quantity: quantityController.text.trim(),
        unit: unitController.text.trim(),
        category: model.selectedCategory ?? 'Khác',
        status: false,
      );
      Navigator.pop(context, ingredient);
    },
    child: Text(
      functionName,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
