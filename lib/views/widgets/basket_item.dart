import 'package:benri_app/models/ingredients/ingredients.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BasketItem extends StatelessWidget {
  final Ingredient ingredient;
  final int index;
  final bool isSelected;
  final BasketViewModel basketViewModel;
  Function(BuildContext)? deleteFunction;

  BasketItem({
    super.key,
    required this.ingredient,
    required this.isSelected,
    required this.basketViewModel,
    required this.index,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: deleteFunction,
            icon: Icons.delete,
            backgroundColor: Colors.red.shade300,
            flex: 1,
            autoClose: true,
          )
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
            Text(
              ingredient.name,
              style: TextStyle(
                  fontSize: 16,
                  decoration: ingredient.isSelected
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
          ],
        ),
      ),
    );
  }
}
