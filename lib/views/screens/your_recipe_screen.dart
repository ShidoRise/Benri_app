import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:benri_app/views/widgets/my_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/colors.dart';
import 'recipe_detail_screen.dart';

class YourRecipeScreen extends StatelessWidget {
  const YourRecipeScreen({super.key});

  void removeFromFavourite(Recipes recipe, BuildContext context) {
    final Recipe = context.read<FavouriteRecipeProvider>();

    Recipe.removeFromFavourite(recipe);
  }

  void navigateToRecipeDetails(BuildContext context, Recipes recipe) {
    final recipes = context.read<FavouriteRecipeProvider>();
    final recipeMenu = recipes.recipes;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(
                  recipe: recipe,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouriteRecipeProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: BAppBar(title: "Your Recipe"),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: MySearchBar(hintText: 'Search your recipe here'),
            ),
            SizedBox(
              height: 0.5,
              child: Container(
                decoration: BoxDecoration(color: BColors.grey),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: value.favouriteRecipes.length,
                  itemBuilder: (context, index) {
                    final Recipes recipe = value.favouriteRecipes[index];

                    return Slidable(
                      endActionPane:
                          ActionPane(motion: const StretchMotion(), children: [
                        SlidableAction(
                          onPressed: (context) =>
                              removeFromFavourite(recipe, context),
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          // borderRadius: BorderRadius.circular(12),
                        )
                      ]),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: BColors.grey, width: 0.5)),
                        ),
                        child: ListTile(
                          leading: Padding(
                            padding: EdgeInsets.only(right: 6, left: 4),
                            child: Container(
                              height: 100,
                              width: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      width: 0.5, color: BColors.grey)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  recipe.imgPath, // Use the getImagePath method
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            recipe.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(recipe.timeCooking)],
                          ),
                          onTap: () {
                            navigateToRecipeDetails(context, recipe);
                          },
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
