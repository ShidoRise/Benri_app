import 'dart:io';

import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipes recipe; // Pass the recipe as a parameter

  const RecipeDetailScreen(
      {super.key, required this.recipe}); // Constructor with required recipe

  @override
  Widget build(BuildContext context) {
    // Access the provider directly for checking and toggling favorites
    final favouriteRecipeProvider = context.watch<FavouriteRecipeProvider>();

    // Check if this recipe is a favourite
    bool isFavourite = favouriteRecipeProvider.isFavourite(recipe);

    return Scaffold(
      appBar: BAppBar(title: recipe.name),
      body: Column(
        // ListView for food detail
        children: [
          Expanded(
            child: ListView(
              children: [
                if (recipe.imgPath.startsWith('/data/'))
                  Image.file(
                    File(recipe.imgPath), // Load image from file
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                else
                  Image.asset(
                    recipe.imgPath, // Load image from assets
                    // height: 200,
                    // width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow[800],
                            size: 25,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            recipe.rating,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: () {
                            // Toggle favourite status using the provider
                            favouriteRecipeProvider.toggleFavourite(recipe);

                            // Show Snackbar for feedback
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFavourite
                                      ? "Removed from Favourites"
                                      : "Added to Favourites",
                                ),
                              ),
                            );
                          },
                          child: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavourite ? Colors.red : Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    recipe.name,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Description",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    recipe.description,
                    style: TextStyle(color: Colors.grey[600], height: 2),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
