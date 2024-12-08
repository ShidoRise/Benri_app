import 'dart:math';
import 'package:benri_app/services/recipes_service.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/views/screens/your_recipe_screen.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:benri_app/views/widgets/my_search_bar.dart';
import 'package:benri_app/views/widgets/recipe_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar(title: 'Recipe'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Consumer<FavouriteRecipeProvider>(
                builder: (context, provider, child) {
                  return MySearchBar(
                    searchController: provider.searchController,
                    hintText: 'Search your favourite recipe',
                  );
                },
              ),
            ),

            // Explore Section
            Container(
              padding: EdgeInsets.only(bottom: 12, left: 20),
              margin: EdgeInsets.symmetric(horizontal: 12),
              height: 180,
              decoration: BoxDecoration(
                color: BColors.accent,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image:
                      AssetImage('assets/images/deco/background_explore.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        "Get your Recipes",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: BColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Text(
                            "Explore Now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Favorite Recipes Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Your Recipes",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.favorite_border_outlined, color: Colors.red),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const YourRecipeScreen(),
                      ),
                    ),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Colors.blue[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Favorite Recipes List
            Consumer<FavouriteRecipeProvider>(
              builder: (context, provider, child) {
                final favoriteRecipes = provider.recipes
                    .where((recipe) => RecipesService.isFavorite(recipe))
                    .toList();

                if (favoriteRecipes.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "You don't have any favourite recipes\nPlease find more!!!",
                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                    ),
                  );
                }

                return SizedBox(
                  height: 264,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: min(10, favoriteRecipes.length),
                    itemBuilder: (context, index) => RecipeTile(
                      recipe: favoriteRecipes[index],
                      onTap: () => provider.navigateToRecipeDetails(
                        context,
                        favoriteRecipes[index],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Recommended Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "Highly Recommend",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Icon(Icons.whatshot, color: Colors.red, size: 30),
                ],
              ),
            ),

            // Recommended Recipes Grid
            Consumer<FavouriteRecipeProvider>(
              builder: (context, provider, child) {
                final shuffledRecipes = List.from(provider.recipes)..shuffle();
                final recommendedRecipes = shuffledRecipes.take(10).toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 4,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: recommendedRecipes.length,
                    itemBuilder: (context, index) {
                      return RecipeTile(
                        recipe: recommendedRecipes[index],
                        onTap: () => provider.navigateToRecipeDetails(
                          context,
                          recommendedRecipes[index],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
