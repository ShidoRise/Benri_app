import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/views/screens/recipe_detail_screen.dart';
import 'package:benri_app/views/screens/your_recipe_screen.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:benri_app/views/widgets/my_search_bar.dart';
import 'package:benri_app/views/widgets/recipe_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  //navigate to detail page
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
    final recipes = context.read<FavouriteRecipeProvider>();
    final recipeMenu = recipes.recipes;
    final favouriteRecipe = recipes.favouriteRecipes;

    return Scaffold(
      appBar: BAppBar(title: 'Recipe'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: MySearchBar(hintText: 'Search your favourite recipe'),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 12, left: 20),
              margin: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: BColors.accent,
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Get your Recipes",
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: BColors.white),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              color: BColors.white,
                              borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Get started",
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Image.asset(
                    'assets/images/deco/Pho Bo.png',
                    height: 140,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Hot Today",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Icon(
                    Icons.whatshot,
                    color: Colors.red,
                    size: 30,
                  )
                ],
              ),
            ),
            Container(
              height: 260, // fixed height for horizontal list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recipeMenu.length,
                itemBuilder: (context, index) => RecipeTile(
                  recipe: recipeMenu[index],
                  onTap: () => navigateToRecipeDetails(context, index),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              YourRecipeScreen(), // Replace with your target page widget
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          "Your recipe",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                // disable scrolling within list
                itemCount: favouriteRecipe.length,
                itemBuilder: (context, index) => RecipeTile(
                  recipe: favouriteRecipe[index],
                  onTap: () {},
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
