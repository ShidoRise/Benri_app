import 'dart:io';

import 'package:benri_app/models/recipes/recipes.dart';
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
            value.favouriteRecipes.isEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'You dont have any favourite recipe',
                          style:
                              TextStyle(fontSize: 20, color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: value.favouriteRecipes.length,
                        itemBuilder: (context, index) {
                          final Recipes recipe = value.favouriteRecipes[index];

                          return Slidable(
                            endActionPane: ActionPane(
                                motion: const StretchMotion(), children: []),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: BColors.grey, width: 0.5)),
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
                                      child: recipe.imgPath.startsWith('/data/')
                                          ? Image.file(
                                              File(recipe
                                                  .imgPath), // Load image from the local file system
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              recipe
                                                  .imgPath, // Load image from assets
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
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.lock_clock,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        Text(recipe.timeCooking),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center, // Center alignment as a starting point
                                      children: [
                                        Baseline(
                                          baseline:
                                              14.0, // Adjust this value for perfect alignment
                                          baselineType: TextBaseline.alphabetic,
                                          child: Text(
                                            recipe.rating,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Baseline(
                                          baseline:
                                              14.0, // Ensure this matches the baseline of the previous text
                                          baselineType: TextBaseline.alphabetic,
                                          child: Text(
                                            '/5',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Baseline(
                                          baseline:
                                              16.0, // Same baseline to keep everything aligned
                                          baselineType: TextBaseline.alphabetic,
                                          child: Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                onTap: () {
                                  value.navigateToRecipeDetails(
                                      context, recipe);
                                },
                              ),
                            ),
                          );
                        }),
                  ),
          ],
        ),
        floatingActionButton: Container(
          height: 65,
          width: 65,
          margin: EdgeInsets.all(5.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateRecipe()));
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
