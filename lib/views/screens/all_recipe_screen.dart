import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/view_models/profile_viewmodel.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:benri_app/views/widgets/recipe_tile.dart';
import 'package:benri_app/views/widgets/setting_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benri_app/views/widgets/text_title_setting_widget.dart';

class AllRecipeScreen extends StatelessWidget {
  final List<Recipes> recipes;
  const AllRecipeScreen({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar(
        title: 'Đề Xuất Công Thức Nấu Ăn',
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: (value) =>
                  context.read<FavouriteRecipeProvider>().searchRecipes(value),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm món ăn...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: BColors.primaryFirst),
                ),
              ),
            ),
          ),
          // Categories Section
          Consumer<FavouriteRecipeProvider>(
            builder: (context, viewModel, child) {
              return SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  itemCount: viewModel.categories.length,
                  itemBuilder: (context, index) {
                    final category = viewModel.categories[index];
                    final isSelected = viewModel.selectedCategory == category;

                    return GestureDetector(
                      onTap: () => viewModel.filterByCategory(category),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? BColors.primaryFirst
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
                              color:
                                  isSelected ? Colors.white : Colors.grey[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(height: 12),
          // Recipes Grid
          Expanded(
            child: Consumer<FavouriteRecipeProvider>(
              builder: (context, provider, child) {
                final filteredRecipes = provider.getFilteredRecipes(recipes);

                return filteredRecipes.isEmpty
                    ? Center(
                        child: Text('No recipes found',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            )),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 4,
                            childAspectRatio: 0.72,
                          ),
                          itemCount: filteredRecipes.length,
                          itemBuilder: (context, index) {
                            return RecipeTile(
                              recipe: filteredRecipes[index],
                              onTap: () => provider.navigateToRecipeDetails(
                                context,
                                filteredRecipes[index],
                              ),
                            );
                          },
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
