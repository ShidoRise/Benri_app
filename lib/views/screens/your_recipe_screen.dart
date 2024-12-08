import 'dart:io';

import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/services/recipes_service.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:benri_app/views/widgets/create_recipe.dart';
import 'package:benri_app/views/widgets/my_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/colors.dart';

class YourRecipeScreen extends StatelessWidget {
  const YourRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouriteRecipeProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: BAppBar(title: "Your Recipe"),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: MySearchBar(
                searchController: provider.searchController,
                hintText: 'Search your recipe here',
              ),
            ),
            SizedBox(
              height: 0.5,
              child: Container(
                decoration: const BoxDecoration(color: BColors.grey),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Recipes>>(
                future: RecipesService.getAllRecipes(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final recipes = snapshot.data!
                      .where((recipe) => RecipesService.isFavorite(recipe))
                      .toList();

                  if (recipes.isEmpty) {
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'You don\'t have any favourite recipes',
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[500]),
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) {
                                provider.toggleFavourite(recipe);
                              },
                              icon: Icons.favorite,
                              backgroundColor: Colors.red,
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(color: BColors.grey, width: 0.5),
                            ),
                          ),
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.only(right: 6, left: 4),
                              child: Container(
                                height: 100,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: recipe.imgPath.startsWith('/data/')
                                        ? FileImage(File(recipe.imgPath))
                                        : AssetImage(recipe.imgPath)
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(recipe.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 14),
                                    const SizedBox(width: 4),
                                    Text(recipe.timeCooking),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(recipe.rating),
                                    const Text(' /5'),
                                    const Icon(Icons.star,
                                        color: Colors.amber, size: 18),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () => provider.navigateToRecipeDetails(
                                context, recipe),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          height: 65,
          width: 65,
          margin: const EdgeInsets.all(5.0),
          child: FloatingActionButton(
            heroTag: 'your_recipe_fab',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateRecipe()),
              );
            },
            backgroundColor: BColors.white,
            child: const Icon(
              Icons.add,
              size: 30,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
