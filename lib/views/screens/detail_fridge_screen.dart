import 'package:benri_app/views/widgets/ingredient_fridge_show.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/ingredient_provider.dart';

class DetailFridgeScreen extends StatelessWidget {
  const DetailFridgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IngredientProvider>(
        builder: (context, provider, child) {
          final ingredientsWithDrawers = provider.getAllIngredientsWithDrawer();

          return ingredientsWithDrawers.isEmpty
              ? const Center(child: Text('Không có thực phẩm trong tủ lạnh'))
              : ListView.builder(
                  itemCount: ingredientsWithDrawers.length,
                  itemBuilder: (context, index) {
                    final ingredientData = ingredientsWithDrawers[index];
                    final drawerName = ingredientData['drawerName'];
                    final ingredient = ingredientData['ingredient'];

                    return IngredientFridgeShow(
                      ingredient: ingredient,
                      drawerName: drawerName,
                      ingredientProvider: provider,
                    );
                  },
                );
        },
      ),
    );
  }
}
