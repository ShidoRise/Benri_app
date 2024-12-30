import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/models/ingredients/basket_ingredients.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class IngredientRecipeTile extends StatelessWidget {
  final FridgeIngredient ingredient;

  const IngredientRecipeTile({
    super.key,
    required this.ingredient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '${ingredient.name}: ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${ingredient.quantity} ${ingredient.unit}',
                    style: TextStyle(
                      fontSize: 14,
                      color: BColors.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            IconButton(
              onPressed: () {
                final basketViewModel =
                    Provider.of<BasketViewModel>(context, listen: false);

                final basketIngredient = BasketIngredient(
                  name: ingredient.name,
                  quantity: ingredient.quantity,
                  unit: ingredient.unit ?? '',
                  imageUrl: '',
                  category: 'Khác',
                );

                basketViewModel.addIngredient(basketIngredient);

                Fluttertoast.showToast(
                  msg:
                      'Đã thêm ${ingredient.name} vào giỏ ngày ${basketViewModel.focusDateFormatted}',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: BColors.primaryFirst,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
              icon: const Icon(
                Iconsax.bag_2,
                color: BColors.primaryFirst,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
