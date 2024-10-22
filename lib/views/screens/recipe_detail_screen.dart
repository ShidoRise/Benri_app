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
  void addToFavouriteRecipe() {
    final favouriteRecipe = context.read<FavouriteRecipeProvider>();

    favouriteRecipe.addToFavourite(widget.recipe);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Successfull")));
  }

  @override
  Widget build(BuildContext context) {
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
                          onTap: addToFavouriteRecipe,
                          child: Icon(Icons.favorite)),
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
                  "To make grilled pork belly, first marinate the pork with a mix of garlic, soy sauce, honey, black pepper, and sesame oil for at least 2 hours. Preheat the grill to medium-high heat. Place the pork belly slices on the grill, cooking each side for about 4-5 minutes or until golden brown and crispy. Use tongs to flip and baste with leftover marinade for extra flavor. Let it rest for a few minutes after grilling, then slice into bite-sized pieces. Serve with dipping sauces or alongside rice and vegetables for a delicious meal. Thank you for your watching, wait us more recipes",
                  style: TextStyle(color: Colors.grey[600], height: 2),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
