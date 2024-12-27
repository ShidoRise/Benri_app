import 'package:benri_app/models/families/family_ingredients.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FamilyItem extends StatelessWidget {
  final FamilyIngredient ingredient;
  final int index;
  final bool status;
  final BasketViewModel basketViewModel;
  final Function(BuildContext)? deleteFunction;
  final Function(BuildContext)? editFunction;

  const FamilyItem({
    super.key,
    required this.ingredient,
    required this.status,
    required this.basketViewModel,
    required this.index,
    required this.deleteFunction,
    required this.editFunction,
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
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: BColors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                activeColor: BColors.primaryFirst,
                value: ingredient.status,
                onChanged: (value) {
                  print('Toggling ingredient selection');
                  basketViewModel.toggleFamilyIngredientSelection(index);
                },
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: TextStyle(
                      fontSize: 16,
                      decoration: ingredient.status
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                Text(
                  '${ingredient.quantity} ${ingredient.unit}',
                  style: TextStyle(
                      fontSize: 16,
                      decoration: ingredient.status
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                Text(
                  ingredient.category,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
