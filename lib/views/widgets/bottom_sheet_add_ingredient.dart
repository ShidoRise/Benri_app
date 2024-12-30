import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/ingredient_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Future<FridgeIngredient?> addFridgeIngredientDialog(
  BuildContext context, {
  FridgeIngredient? fridgeIngredient,
}) {
  final nameController =
      TextEditingController(text: fridgeIngredient?.name ?? '');
  final quantityController =
      TextEditingController(text: fridgeIngredient?.quantity ?? '');
  final unitController =
      TextEditingController(text: fridgeIngredient?.unit ?? '');
  final provider = Provider.of<IngredientProvider>(context, listen: false);

  bool isInitialized = false;

  if (fridgeIngredient != null) {
    provider.initializeExpirationDate(fridgeIngredient.expirationDate);
  } else {
    provider.clearExpirationDate();
  }

  return showModalBottomSheet<FridgeIngredient>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => ChangeNotifierProvider<IngredientProvider>.value(
      value: provider,
      child: Consumer<IngredientProvider>(
        builder: (context, model, _) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 20,
            right: 20,
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
                _buildExpirationDateField(context, model),
                const SizedBox(height: 16),
                _buildQuickDateButtons(context, model),
                const SizedBox(height: 24),
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
                        child: const Text(
                          'Hủy',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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
                          } else if (model.expirationDate == null) {
                            Fluttertoast.showToast(
                                msg: 'Vui lòng chọn ngày hết hạn');
                            return;
                          }

                          Navigator.pop(
                            context,
                            FridgeIngredient(
                              name: nameController.text,
                              quantity: quantityController.text,
                              unit: unitController.text,
                              expirationDate: model.expirationDate!,
                              imgPath: model.getImageUrlFromLocalStorage(
                                  nameController.text),
                            ),
                          );
                        },
                        child: Text(
                          fridgeIngredient == null ? 'Thêm' : 'Cập nhật',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
  IngredientProvider model,
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
  IngredientProvider model,
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

Widget _buildExpirationDateField(
    BuildContext context, IngredientProvider model) {
  return InkWell(
    onTap: () async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: model.expirationDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        model.setExpirationDate(picked);
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            model.expirationDate != null
                ? DateFormat('dd/MM/yyyy').format(model.expirationDate!)
                : 'Chọn ngày hết hạn',
            style: TextStyle(
              color: model.expirationDate != null ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildQuickDateButtons(BuildContext context, IngredientProvider model) {
  return Wrap(
    spacing: 3,
    runSpacing: 8,
    children: [
      _buildDateChip(context, '3 ngày', 3, model),
      _buildDateChip(context, '1 tuần', 7, model),
      _buildDateChip(context, '2 tuần', 14, model),
      _buildDateChip(context, '1 tháng', 30, model),
    ],
  );
}

Widget _buildDateChip(
  BuildContext context,
  String label,
  int days,
  IngredientProvider model,
) {
  return ActionChip(
    label: Text(label),
    onPressed: () => model.setExpirationDays(days),
    backgroundColor: Colors.white,
    side: BorderSide(color: Colors.black.withOpacity(0.4)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}
