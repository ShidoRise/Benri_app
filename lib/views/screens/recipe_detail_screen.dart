import 'dart:io';
import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/services/recipe_service.dart';
import 'package:benri_app/view_models/ingredient_provider.dart';
import 'package:benri_app/views/widgets/ingredient_recipe_tile.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../view_models/favourite_recipe_provider.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipes recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isShowAll = false; // Move isShowAll here

  void toggleShow() {
    setState(() {
      isShowAll = !isShowAll; // Toggle isShowAll
    });
  }

  @override
  Widget build(BuildContext context) {
    final favouriteRecipeProvider = context.watch<FavouriteRecipeProvider>();
    bool isFavourite = favouriteRecipeProvider.isFavourite(widget.recipe);
    final List<Map<String, dynamic>> ingredientStatus =
        RecipeService().checkIngredientsAvailable(widget.recipe.ingredients);
    final ingredientProvider =
        Provider.of<IngredientProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2.1,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: widget.recipe.imgPath.startsWith('/data/')
                              ? FileImage(File(widget.recipe.imgPath))
                              : AssetImage(widget.recipe.imgPath)
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: MediaQuery.of(context).size.width,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    width: 40,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          widget.recipe.name,
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: () {
                            favouriteRecipeProvider
                                .toggleFavourite(widget.recipe);

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
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    children: [
                      const Icon(Iconsax.clock, size: 20, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        widget.recipe.timeCooking,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    children: [
                      Baseline(
                          baseline: 20.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Icon(Icons.star,
                              color: Colors.yellow[800], size: 25)),
                      SizedBox(width: 5),
                      Baseline(
                        baseline: 20.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          widget.recipe.rating,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Baseline(
                        baseline: 20.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          ' /5',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Ingredients",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ConstrainedBox(
                  constraints: isShowAll
                      ? BoxConstraints(
                          maxHeight: widget.recipe.ingredients.length * 84)
                      : BoxConstraints(maxHeight: 252),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.recipe.ingredients.isEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'No Data Found',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 16),
                              ),
                            ],
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: ingredientStatus
                                .length, // Update to use ingredientStatus list
                            itemBuilder: (context, index) {
                              final ingredient =
                                  ingredientStatus[index]['ingredient'];
                              final isAvailable =
                                  ingredientStatus[index]['isAvailable'];
                              final drawerName =
                                  ingredientStatus[index]['drawerName'];

                              final imgUrl = ingredientProvider
                                  .getImageUrlFromLocalStorage(
                                      widget.recipe.ingredients[index].name);

                              return IngredientRecipeTile(
                                ingredient: ingredient,
                                isAvailable: isAvailable,
                                drawerName: drawerName,
                                imgUrl: imgUrl,
                              );
                            },
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GestureDetector(
                        onTap: toggleShow,
                        child: Text(
                          isShowAll ? 'Show less' : 'Show all',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.recipe.description,
                    style: TextStyle(color: Colors.grey[600], height: 2),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
