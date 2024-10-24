import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipes recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  void toggleFavouriteRecipe() {
    final favouriteRecipeProvider = context.read<FavouriteRecipeProvider>();

    if (favouriteRecipeProvider.favouriteRecipes.contains(widget.recipe)) {
      favouriteRecipeProvider
          .removeFromFavourite(widget.recipe); // Remove from favourites
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Removed from Favourites")));
    } else {
      favouriteRecipeProvider
          .addToFavourite(widget.recipe); // Add to favourites
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Added to Favourites")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final favouriteRecipeProvider = context.watch<FavouriteRecipeProvider>();
    bool isFavourite =
        favouriteRecipeProvider.favouriteRecipes.contains(widget.recipe);
    return Scaffold(
      appBar: BAppBar(title: widget.recipe.name),
      body: Column(
        //listview food detail
        children: [
          Expanded(
              child: ListView(
            children: [
              Image.asset(
                widget.recipe.imgPath,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
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
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.recipe.rating,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: GestureDetector(
                          onTap: toggleFavouriteRecipe,
                          child: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavourite ? Colors.red : Colors.grey,
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.recipe.name,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Description",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.recipe.description,
                  style: TextStyle(color: Colors.grey[600], height: 2),
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ))
        ],
      ),
    );
  }
}
