import 'dart:math';
import 'package:benri_app/services/recipes_service.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/views/screens/all_recipe_screen.dart';
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
      appBar: BAppBar(
        title: 'Recipe',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Add your refresh logic here
          await Provider.of<FavouriteRecipeProvider>(context, listen: false)
              .initializeData();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
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
                          "Khám Phá Công Thức Nấu Ăn",
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
                              "Khám phá ngay",
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Công thức của bạn",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondaryFixed,
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
                        'Xem tất cả',
                        style: TextStyle(
                          color: BColors.primaryFirst,
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
                  final favoriteRecipes = provider.favouriteRecipes;

                  if (favoriteRecipes.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Bạn chưa có công thức nấu ăn yêu thích nào\nHãy khám phá thêm nhé!!!",
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
              Consumer<FavouriteRecipeProvider>(
                  builder: (context, viewModel, child) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Đề xuất",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).colorScheme.secondaryFixed,
                            ),
                          ),
                          const Icon(Icons.whatshot,
                              color: Colors.red, size: 30),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllRecipeScreen(
                              recipes: viewModel.recipes,
                            ),
                          ),
                        ),
                        child: Text(
                          'Xem tất cả',
                          style: TextStyle(
                            color: BColors.primaryFirst,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Categories Section
              Consumer<FavouriteRecipeProvider>(
                builder: (context, viewModel, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categories List
                      SizedBox(
                        height: 44,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          itemCount: viewModel.categories.length,
                          itemBuilder: (context, index) {
                            final category = viewModel.categories[index];
                            final isSelected =
                                viewModel.selectedCategory == category;

                            return GestureDetector(
                              onTap: () => viewModel.filterByCategory(category),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? BColors.primaryFirst
                                      : Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[800]
                                          : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? BColors.primaryFirst
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.grey[800],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 12,
              ),

              // Recommended Recipes Grid
              Consumer<FavouriteRecipeProvider>(
                builder: (context, viewModel, child) {
                  final shuffledRecipes;
                  if (viewModel.filterRecipes.isEmpty) {
                    shuffledRecipes = List.from(viewModel.recipes);
                  } else {
                    shuffledRecipes = List.from(viewModel.filterRecipes);
                  }
                  final recommendedRecipes = shuffledRecipes.take(10).toList();
                  print(recommendedRecipes.length);
                  if (recommendedRecipes.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Không tìm thấy công thức nấu ăn nào được đề xuất",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[500]),
                        ),
                      ),
                    );
                  }
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
                          onTap: () => viewModel.navigateToRecipeDetails(
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
      ),
    );
  }
}
