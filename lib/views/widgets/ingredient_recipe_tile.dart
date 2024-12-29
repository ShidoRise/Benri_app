import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IngredientRecipeTile extends StatelessWidget {
  final FridgeIngredient ingredient;
  final bool? isAvailable;
  String? drawerName;
  final String imgUrl;

  IngredientRecipeTile(
      {super.key,
      required this.ingredient,
      this.isAvailable,
      this.drawerName,
      required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    print('${ingredient.quantity} --unit :: ${ingredient.unit}');
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 0.25),
              top: BorderSide(color: Colors.grey.shade300, width: 0.25))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredient.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'Quantity: ${ingredient.quantity}${ingredient.unit}',
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isAvailable != null)
                    Row(
                      children: [
                        Icon(
                          isAvailable! ? Icons.check : Icons.warning,
                          color: isAvailable! ? Colors.green : Colors.red,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isAvailable!
                              ? 'Available in: $drawerName'
                              : 'Not available in your firdge',
                          style: TextStyle(
                            color: isAvailable! ? Colors.green : Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
