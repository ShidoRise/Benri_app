import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/ingredient_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class IngredientFridgeView extends StatelessWidget {
  final FridgeIngredient ingredient;
  final IngredientProvider? ingredientProvider;
  final Function(BuildContext)? editIngredient;
  final Function(BuildContext)? deleteIngredient;

  const IngredientFridgeView(
      {super.key,
      required this.ingredient,
      required this.deleteIngredient,
      required this.editIngredient,
      required this.ingredientProvider});

  String getFormattedExpirationDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    bool isExpired = DateTime.now().isAfter(ingredient.expirationDate!);
    String expirationText = isExpired
        ? 'Hết hạn vào: ${getFormattedExpirationDate(ingredient.expirationDate!)}'
        : 'Hết hạn vào: ${getFormattedExpirationDate(ingredient.expirationDate!)}';

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: editIngredient,
              icon: Icons.edit,
              backgroundColor: BColors.grey,
            ),
            SlidableAction(
              onPressed: deleteIngredient,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
            ),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: BColors.grey, width: 0.5)),
          ),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(right: 6, left: 4),
              child: Container(
                height: 100,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 0.5, color: BColors.grey)),
                child: (ingredient.imgPath != ''
                    ? Image.network(
                        ingredient.imgPath,
                        width: 80,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/ingredient/default.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/ingredient/default.png',
                        width: 80,
                      )),
              ),
            ),
            title: Text(
              ingredient.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${ingredient.quantity} ${ingredient.unit}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  expirationText,
                  style: TextStyle(
                    fontSize: 14,
                    color: isExpired ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
