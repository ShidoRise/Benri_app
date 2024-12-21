import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/view_models/recipe_creation_provider.dart';
import 'package:benri_app/views/widgets/add_ingredient_recipe_dialog.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:benri_app/views/widgets/ingredient_recipe_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRecipe extends StatelessWidget {
  const CreateRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecipeCreationProvider(),
      child: Consumer<RecipeCreationProvider>(
        builder: (context, recipeCreationProvider, child) {
          return WillPopScope(
            onWillPop: () async {
              context.read<FavouriteRecipeProvider>().clearImageFile();
              return true; // Allow the pop action (exit the screen)
            },
            child: Scaffold(
              appBar: BAppBar(title: 'Create Recipe'),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      TextField(
                        controller: recipeCreationProvider.nameController,
                        decoration: InputDecoration(
                          label: const Text('Your recipe name'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: recipeCreationProvider.ratingController,
                        decoration: InputDecoration(
                          label: const Text('Your rating'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller:
                            recipeCreationProvider.timeCookingController,
                        decoration: InputDecoration(
                          label: const Text('Time Cooking'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.only(left: 6, top: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Ingredients',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      // Display the list of ingredients added
                      recipeCreationProvider.ingredients.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  recipeCreationProvider.ingredients.length,
                              itemBuilder: (context, index) {
                                final ingredient =
                                    recipeCreationProvider.ingredients[index];
                                return IngredientRecipeTile(
                                  ingredient: ingredient,
                                  isAvailable: null,
                                  imgUrl:
                                      'assets/images/ingredient/default.png',
                                );
                              },
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('Bạn chưa thêm nguyên liệu'),
                                ),
                              ],
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BColors.primaryFirst,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              final newIngredient =
                                  await addIngredientRecipeDialog(context);
                              if (newIngredient != null) {
                                recipeCreationProvider
                                    .addIngredient(newIngredient);
                              }
                            },
                            child: Text('Thêm nguyên liệu',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller:
                            recipeCreationProvider.descriptionController,
                        decoration: InputDecoration(
                          label: const Text('Description'),
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        minLines: 5,
                        maxLines: null,
                      ),
                      const SizedBox(height: 8),
                      Consumer<FavouriteRecipeProvider>(
                        builder: (context, recipeProvider, child) {
                          return Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Choose a photo'),
                                ),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () =>
                                    recipeProvider.pickImageFromGallery(),
                                child: Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: recipeProvider.imageFile == null
                                      ? Center(
                                          child: Icon(Icons
                                              .add_photo_alternate_outlined))
                                      : Image.file(
                                          recipeProvider.imageFile!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: BColors.primaryFirst,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14))),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      // foregroundColor: Colors.white,
                                      backgroundColor: BColors.primaryFirst,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (recipeCreationProvider.nameController.text.isNotEmpty &&
                                          recipeCreationProvider
                                              .timeCookingController
                                              .text
                                              .isNotEmpty &&
                                          recipeCreationProvider
                                              .ratingController
                                              .text
                                              .isNotEmpty) {
                                        recipeProvider.addNewRecipe(
                                          recipeCreationProvider
                                              .nameController.text,
                                          recipeCreationProvider
                                              .descriptionController.text,
                                          // ignore: prefer_interpolation_to_compose_strings
                                          recipeCreationProvider
                                                  .timeCookingController.text +
                                              ' mins',
                                          recipeCreationProvider
                                              .ratingController.text,
                                          recipeCreationProvider.ingredients,
                                        );
                                        Navigator.of(context).pop();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Please fill all the text fields')),
                                        );
                                      }
                                    },
                                    child: const Text('Add New Recipe',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
