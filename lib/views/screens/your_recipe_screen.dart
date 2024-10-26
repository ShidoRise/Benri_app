import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class YourRecipeScreen extends StatelessWidget {
  const YourRecipeScreen({super.key});

  void removeFromFavourite(Recipes recipe, BuildContext context) {
    final Recipe = context.read<FavouriteRecipeProvider>();

    Recipe.removeFromFavourite(recipe);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouriteRecipeProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: BAppBar(title: "Your Recipe"),
        body: ListView.builder(
            itemCount: value.favouriteRecipes.length,
            itemBuilder: (context, index) {
              final Recipes recipe = value.favouriteRecipes[index];

              final String recipeName = recipe.name;

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
                child: ListTile(
                  title: Text(recipeName),
                ),
              );
            }),
      ),
    );
  }
}
