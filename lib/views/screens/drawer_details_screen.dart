import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/ingredient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/bottom_sheet_add_ingredient.dart';
import '../widgets/ingredient_fridge_view.dart';
// Import IngredientProvider

class DrawerDetailsScreen extends StatelessWidget {
  final String drawerName;
  const DrawerDetailsScreen({super.key, required this.drawerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(drawerName),
        backgroundColor: BColors.accent,
      ),
      body: Consumer<IngredientProvider>(
        builder: (context, provider, child) {
          final ingredients = provider.db.fridgeIngredients[drawerName];
          return (ingredients?.isNotEmpty ?? false)
              ? ListView.builder(
                  itemCount: ingredients?.length ?? 0,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    return IngredientFridgeView(
                      ingredient: ingredients![index],
                      deleteIngredient: (context) =>
                          provider.removeIngredient(drawerName, index),
                      editIngredient: (context) =>
                          {provider.editIngredient(context, drawerName, index)},
                      ingredientProvider: provider,
                    );
                  },
                )
              : const Center(child: Text('No ingredients in the fridge yet.'));
        },
      ),
      floatingActionButton: Container(
        height: 65,
        width: 65,
        margin: EdgeInsets.all(5),
        child: FloatingActionButton(
          onPressed: () async {
            final newIngredient = await addFridgeIngredientDialog(context);
            if (newIngredient != null) {
              Provider.of<IngredientProvider>(context, listen: false)
                  .addIngredient(drawerName, newIngredient);
            }
          },
          backgroundColor: BColors.white,
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
