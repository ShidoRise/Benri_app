import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:intl/intl.dart'; // For formatting the date

// ignore: must_be_immutable
class IngredientFridgeView extends StatefulWidget {
  final FridgeIngredient ingredient;
  final String? drawerName;
  Function(BuildContext)? deleteIngredient;

  IngredientFridgeView({
    super.key,
    required this.ingredient,
    this.drawerName,
    required this.deleteIngredient,
  });

  @override
  State<IngredientFridgeView> createState() => _IngredientFridgeViewState();
}

class _IngredientFridgeViewState extends State<IngredientFridgeView> {
  // Format the expiration date
  String getFormattedExpirationDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    bool isExpired = DateTime.now().isAfter(widget.ingredient.expirationDate);
    String expirationText = isExpired
        ? 'Expired on: ${getFormattedExpirationDate(widget.ingredient.expirationDate)}'
        : 'Expires on: ${getFormattedExpirationDate(widget.ingredient.expirationDate)}';

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: (context) => widget.deleteIngredient!(context),
            icon: Icons.delete,
            backgroundColor: Colors.red,
            // borderRadius: BorderRadius.circular(12),
          )
        ]),
        child: Container(
          // margin: const EdgeInsets.all(8.0),
          // padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(10),
            border: Border(bottom: BorderSide(color: BColors.grey, width: 0.5)),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 2,
            //     blurRadius: 5,
            //     offset: const Offset(0, 3), // changes position of shadow
            //   ),
            // ],
          ),
          child: ListTile(
            leading: Padding(
              padding: EdgeInsets.only(right: 6, left: 4),
              child: Container(
                height: 100,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 0.5, color: BColors.grey)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.ingredient
                        .getImagePath(), // Use the getImagePath method
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            title: Text(
              widget.ingredient.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quantity: ${widget.ingredient.quantity}',
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
                if (widget.drawerName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Stored in ${widget.drawerName}',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14),
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
