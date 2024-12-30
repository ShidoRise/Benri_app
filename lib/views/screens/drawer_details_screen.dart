import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/ingredient_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_sheet_add_ingredient.dart';
import '../widgets/ingredient_fridge_view.dart';

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
        builder: (context, provider, _) {
          final ingredients = provider.getIngredientsForDrawer(drawerName);
          return ingredients.isNotEmpty
              ? ListView.builder(
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return IngredientFridgeView(
                      ingredient: ingredients[index],
                      deleteIngredient: (context) =>
                          provider.removeIngredient(drawerName, index),
                      editIngredient: (context) =>
                          provider.editIngredient(context, drawerName, index),
                      ingredientProvider: provider,
                    );
                  },
                )
              : const Center(
                  child: Text('Không có thực phẩm nào trong tủ lạnh'));
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(12),
        child: FloatingActionButton(
          heroTag: 'drawer_detail_${drawerName}_fab',
          onPressed: () async {
            final newIngredient = await addFridgeIngredientDialog(context);
            if (newIngredient != null) {
              if (context.mounted) {
                final provider =
                    Provider.of<IngredientProvider>(context, listen: false);
                provider.resetSelections();
                provider.addIngredient(drawerName, newIngredient);
              }
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
