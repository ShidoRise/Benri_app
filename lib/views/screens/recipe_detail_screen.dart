import 'dart:io';
import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/services/recipes_service.dart';
import 'package:benri_app/view_models/ingredient_provider.dart';
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
        final isFavourite = RecipesService.isFavorite(recipe);
        final ingredientStatus =
            RecipesService.checkIngredientsAvailable(recipe.ingredients);
        final ingredientProvider =
            Provider.of<IngredientProvider>(context, listen: false);

        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              // Main Content
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section with Image
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // Recipe Image
                          Positioned.fill(
                            child: Image(
                              image: recipe.imgPath.startsWith('/data/')
                                  ? FileImage(File(recipe.imgPath))
                                  : AssetImage(recipe.imgPath) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Recipe Info Card
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Recipe Title and Favorite Button
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
                                      GestureDetector(
                                        onTap: () {
                                          provider.toggleFavourite(recipe);
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(
                                                    isFavourite
                                                        ? Icons.favorite_border
                                                        : Icons.favorite,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    isFavourite
                                                        ? "Removed from Favorites"
                                                        : "Added to Favorites",
                                                  ),
                                                ],
                                              ),
                                              backgroundColor: isFavourite
                                                  ? Colors.red
                                                  : Colors.green,
                                              duration:
                                                  const Duration(seconds: 1),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        },
                                        child: AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: Icon(
                                            isFavourite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            key: ValueKey<bool>(isFavourite),
                                            color: isFavourite
                                                ? Colors.red
                                                : Colors.grey,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Time and Rating
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
                    // Ingredients Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ingredients",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ConstrainedBox(
                            constraints: provider.isShowAll
                                ? BoxConstraints(
                                    maxHeight: recipe.ingredients.length * 84)
                                : const BoxConstraints(maxHeight: 252),
                            child: recipe.ingredients.isEmpty
                                ? const Text('No ingredients found')
                                : ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: ingredientStatus.length,
                                    itemBuilder: (context, index) {
                                      final ingredient =
                                          ingredientStatus[index]['ingredient'];
                                      final isAvailable =
                                          ingredientStatus[index]
                                              ['isAvailable'];
                                      final drawerName =
                                          ingredientStatus[index]['drawerName'];
                                      final imgUrl = ingredientProvider
                                          .getImageUrlFromLocalStorage(
                                        recipe.ingredients[index].name,
                                      );

                                      return IngredientRecipeTile(
                                        ingredient: ingredient,
                                        isAvailable: isAvailable,
                                        drawerName: drawerName,
                                        imgUrl: imgUrl,
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
                                  provider.isShowAll ? 'Show less' : 'Show all',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          // Description Section
                          const SizedBox(height: 16),
                          const Text(
                            "Description",
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
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Back Button
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
