import 'package:benri_app/models/ingredients/basket_ingredients.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BasketItem extends StatelessWidget {
  final BasketIngredient ingredient;
  final int index;
  final bool isSelected;
  final BasketViewModel basketViewModel;
  Function(BuildContext)? deleteFunction;
  Function(BuildContext)? editFunction;
  Function(BuildContext)? addToFridgeFunction;

  BasketItem({
    super.key,
    required this.ingredient,
    required this.isSelected,
    required this.basketViewModel,
    required this.index,
    required this.deleteFunction,
    required this.editFunction,
    this.addToFridgeFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: editFunction,
            icon: Icons.edit,
            backgroundColor: BColors.grey,
          ),
          SlidableAction(
            onPressed: deleteFunction,
            icon: Icons.delete,
            backgroundColor: Colors.red.shade300,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: BColors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                activeColor: BColors.primaryFirst,
                value: ingredient.isSelected,
                onChanged: (value) {
                  basketViewModel.toggleIngredientSelection(index);
                },
              ),
            ),
            (ingredient.imageUrl != ''
                ? Image.network(
                    ingredient.imageUrl,
                    width: 80,
                  )
                : Image.asset(
                    'assets/images/ingredient/default.png',
                    width: 80,
                  )),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: TextStyle(
                      fontSize: 16,
                      decoration: ingredient.isSelected
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                Text(
                  '${ingredient.quantity} ${ingredient.unit}',
                  style: TextStyle(
                      fontSize: 16,
                      decoration: ingredient.isSelected
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
