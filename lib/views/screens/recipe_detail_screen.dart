import 'dart:io';
import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/services/recipes_service.dart';
import 'package:benri_app/views/widgets/ingredient_recipe_tile.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../view_models/favourite_recipe_provider.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipes recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouriteRecipeProvider>(
      builder: (context, provider, _) {
        final ingredientStatus =
            RecipesService.checkIngredientsAvailable(recipe.ingredients);
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: recipe.imgPath ==
                                    'assets/images/ingredient/default.png'
                                ? Image.asset(recipe.imgPath)
                                : recipe.imgPath.startsWith('http')
                                    ? Image.network(
                                        recipe.imgPath,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(recipe.imgPath),
                                        fit: BoxFit.cover,
                                      ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          recipe.name,
                                          style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Icon(Iconsax.clock,
                                          size: 20, color: Colors.grey),
                                      const SizedBox(width: 5),
                                      Text(
                                        recipe.timeCooking,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.star,
                                          color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${recipe.rating}/5',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Nguyên liệu:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ConstrainedBox(
                              constraints: provider.isShowAll
                                  ? BoxConstraints(
                                      maxHeight: recipe.ingredients.length * 84)
                                  : const BoxConstraints(maxHeight: 252),
                              child: recipe.ingredients.isEmpty
                                  ? const Text('Không có nguyên liệu nào!')
                                  : ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: ingredientStatus.length,
                                      itemBuilder: (context, index) {
                                        final ingredient =
                                            ingredientStatus[index]
                                                ['ingredient'];
                                        return IngredientRecipeTile(
                                          ingredient: ingredient,
                                        );
                                      },
                                    ),
                            ),
                            if (recipe.ingredients.length > 3)
                              GestureDetector(
                                onTap: provider.toggleShowAll,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    provider.isShowAll
                                        ? 'Xem ít hơn'
                                        : 'Xem tất cả',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            const Text(
                              "Mô tả",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              recipe.description,
                              style: TextStyle(
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 10,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
