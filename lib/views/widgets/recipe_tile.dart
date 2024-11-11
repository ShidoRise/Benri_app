import 'dart:io';

import 'package:flutter/material.dart';
import 'package:benri_app/models/recipes/recipes.dart';
import 'package:provider/provider.dart';

import '../../view_models/favourite_recipe_provider.dart';
import '../screens/recipe_detail_screen.dart';

class RecipeTile extends StatelessWidget {
  final Recipes recipe;
  final void Function()? onTap;
  const RecipeTile({super.key, required this.recipe, required this.onTap});

  void navigateToRecipeDetails(BuildContext context, int index) {
    final recipes = context.read<FavouriteRecipeProvider>();
    final recipeMenu = recipes.recipes;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(
                  recipe: recipeMenu[index],
                )));
  }

  @override
  Widget build(BuildContext context) {
    final favouriteRecipeProvider = context.watch<FavouriteRecipeProvider>();

    // Check if this recipe is a favourite
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
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: recipe.imgPath.startsWith('/data/')
                      ? Image.file(
                          File(recipe.imgPath),
                          height: 160,
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
                          Text(
                            recipe.rating,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 80,
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
                      Row(
                        children: [
                          const Icon(
                            Icons.lock_clock,
                            size: 10,
                          ),
                          Text(
                            recipe.timeCooking,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      // child: GestureDetector(
      //   onTap: onTap,
      //   child: Container(
      //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: BorderRadius.circular(12),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.grey.withOpacity(0.5),
      //           spreadRadius: 2,
      //           blurRadius: 5,
      //           offset: const Offset(0, 3), // changes position of shadow
      //         ),
      //       ],
      //     ),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         ClipRRect(
      //           borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      //           child: Image.asset(
      //             recipe.imgPath,
      //             height: 160,

      //             fit: BoxFit
      //                 .cover, // Ensures the image covers the available space
      //           ),
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.only(
      //               left: 10, right: 12, bottom: 10, top: 10),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                 recipe.name,
      //                 style: TextStyle(
      //                   fontWeight: FontWeight.bold,
      //                   fontSize: 16,
      //                 ),
      //                 overflow: TextOverflow.ellipsis,
      //                 maxLines: 1,
      //               ),
      //               Row(
      //                 children: [
      //                   Text(
      //                     recipe.rating,
      //                     style: TextStyle(fontSize: 14, color: Colors.grey[700]),
      //                   ),
      //                   SizedBox(width: 4),
      //                   Icon(
      //                     Icons.star,
      //                     color: Colors.amber,
      //                     size: 16,
      //                   ),
      //                   SizedBox(
      //                     width: 80,
      //                   ),
      //                   Icon(
      //                     isFavourite ? Icons.favorite : Icons.favorite_border,
      //                     color: isFavourite ? Colors.red : Colors.grey,
      //                     size: 20,
      //                   ),
      //                 ],
      //               ),
      //               Row(
      //                 children: [
      //                   Icon(
      //                     Icons.lock_clock,
      //                     size: 10,
      //                   ),
      //                   Text(
      //                     recipe.timeCooking,
      //                     style: TextStyle(fontSize: 14, color: Colors.grey[700]),
      //                   )
      //                 ],
      //               )
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
