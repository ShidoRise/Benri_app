import 'dart:io';
import 'package:flutter/material.dart';
import 'package:benri_app/models/recipes/recipes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../view_models/favourite_recipe_provider.dart';

class RecipeTile extends StatelessWidget {
  final Recipes recipe;
  final void Function()? onTap;
  const RecipeTile({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final favouriteRecipeProvider = context.watch<FavouriteRecipeProvider>();

    bool isFavourite = favouriteRecipeProvider.isFavourite(recipe);
    return Consumer<FavouriteRecipeProvider>(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: recipe.imgPath.startsWith('/data/')
                      ? Image.file(
                          File(recipe.imgPath),
                          height: 160,
                          width: 160,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          recipe.imgPath,
                          height: 160,

                          fit: BoxFit
                              .cover, // Ensures the image covers the available space
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 12, bottom: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        children: [
                          Icon(
                            Iconsax.clock,
                            size: 14,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            recipe.timeCooking,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            recipe.rating,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '/5',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          SizedBox(
                            width: 64,
                          ),
                          Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavourite ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
