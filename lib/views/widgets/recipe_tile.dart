// recipe_tile.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:benri_app/models/recipes/recipes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:benri_app/services/recipes_service.dart';
import '../../view_models/favourite_recipe_provider.dart';

class RecipeTile extends StatelessWidget {
  final Recipes recipe;
  final void Function()? onTap;

  const RecipeTile({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouriteRecipeProvider>(
      builder: (context, provider, child) {
        final isFavorite = RecipesService.isFavorite(recipe);

        return GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: 200, // Fixed width for the tile
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image(
                        image: recipe.imgPath.startsWith('/data/')
                            ? FileImage(File(recipe.imgPath))
                            : AssetImage(recipe.imgPath) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          recipe.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Iconsax.clock, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              recipe.timeCooking,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  recipe.rating,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '/5',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 18),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                provider.toggleFavourite(recipe);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          isFavorite
                                              ? Icons.favorite_border
                                              : Icons.favorite,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          isFavorite
                                              ? "Removed from Favorites"
                                              : "Added to Favorites",
                                        ),
                                      ],
                                    ),
                                    backgroundColor:
                                        isFavorite ? Colors.red : Colors.green,
                                    duration: const Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                  key: ValueKey<bool>(isFavorite),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
