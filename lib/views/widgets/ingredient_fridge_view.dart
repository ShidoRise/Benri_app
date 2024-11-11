import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:intl/intl.dart'; // For formatting the date

// ignore: must_be_immutable
class IngredientFridgeView extends StatelessWidget {
  final FridgeIngredient ingredient;
  final String? drawerName;
  Function(BuildContext)? editIngredient;
  Function(BuildContext)? deleteIngredient;

  IngredientFridgeView(
      {super.key,
      required this.ingredient,
      this.drawerName,
      required this.deleteIngredient,
      required this.editIngredient});

  // Format the expiration date
  String getFormattedExpirationDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    bool isExpired = DateTime.now().isAfter(ingredient.expirationDate);
    String expirationText = isExpired
        ? 'Expired on: ${getFormattedExpirationDate(ingredient.expirationDate)}'
        : 'Expires on: ${getFormattedExpirationDate(ingredient.expirationDate)}';

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: (context) => deleteIngredient!(context),
            icon: Icons.edit,
            backgroundColor: Colors.grey,
            // borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (context) => deleteIngredient!(context),
            icon: Icons.delete,
            backgroundColor: Colors.red,
            // borderRadius: BorderRadius.circular(12),
          )
        ]),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (ingredient.imgPath != ''
                      ? Image.network(
                          ingredient.imgPath,
                          width: 80,
                        )
                      : Image.asset(
                          'assets/images/ingredient/default.png',
                          width: 80,
                        )),
                ),
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
                  'Quantity: ${ingredient.quantity}',
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
                if (drawerName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Stored in $drawerName',
                      style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
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
