import 'package:benri_app/views/widgets/ingredient_fridge_show.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/ingredient_provider.dart';

class DetailFridgeScreen extends StatelessWidget {
  const DetailFridgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IngredientProvider>(
      builder: (context, provider, child) {
        final sortedIngredients = provider.getSortedIngredients();

        return Stack(
          children: [
            sortedIngredients.isEmpty
                ? const Center(child: Text('Không có thực phẩm trong tủ lạnh'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: sortedIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredientData = sortedIngredients[index];
                      final drawerName = ingredientData['drawerName'];
                      final ingredient = ingredientData['ingredient'];

                      return IngredientFridgeShow(
                        ingredient: ingredient,
                        drawerName: drawerName,
                        ingredientProvider: provider,
                      );
                    },
                  ),
            Positioned(
              top: 8,
              right: 16,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                child: PopupMenuButton<SortMode>(
                  icon: const Icon(Icons.sort),
                  onSelected: provider.setSortMode,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<SortMode>>[
                    const PopupMenuItem<SortMode>(
                      value: SortMode.expirationDate,
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 20),
                          SizedBox(width: 8),
                          Text('Sắp xếp theo ngày hết hạn'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<SortMode>(
                      value: SortMode.compartment,
                      child: Row(
                        children: [
                          Icon(Icons.kitchen, size: 20),
                          SizedBox(width: 8),
                          Text('Sắp xếp theo ngăn tủ'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<SortMode>(
                      value: SortMode.none,
                      child: Row(
                        children: [
                          Icon(Icons.clear_all, size: 20),
                          SizedBox(width: 8),
                          Text('Mặc định'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
