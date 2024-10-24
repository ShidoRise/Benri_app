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

  // Method to show the BottomSheet and add an ingredient
  void addIngredientIntoFridge(BuildContext context) async {
    final newIngredient =
        await addIngredientDialog(context); // Using your BottomSheet dialog
    if (newIngredient != null) {
      Provider.of<IngredientProvider>(context, listen: false)
          .addIngredient(drawerName, newIngredient); // Add to specific drawer
    }
  }

  // Method to delete an ingredient from the fridge
  void deleteIngredientFridge(BuildContext context, int index) {
    Provider.of<IngredientProvider>(context, listen: false)
        .removeIngredient(drawerName, index); // Remove from specific drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(drawerName),
        backgroundColor: BColors.accent,
      ),
      body: Consumer<IngredientProvider>(
        builder: (context, provider, child) {
          final ingredients = provider.getIngredientsForDrawer(
              drawerName); // Get ingredients for this drawer
          return ingredients.isEmpty
              ? const Center(child: Text('No ingredients in the fridge yet.'))
              : ListView.builder(
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return IngredientFridgeView(
                      ingredient: ingredients[index],
                      deleteIngredient: (context) =>
                          deleteIngredientFridge(context, index),
                    );
                  },
                );
        },
      ),
      floatingActionButton: Container(
        height: 65,
        width: 65,
        margin: EdgeInsets.all(5),
        child: FloatingActionButton(
          onPressed: () => addIngredientIntoFridge(context),
          backgroundColor: BColors.white,
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
    );
  }
}
