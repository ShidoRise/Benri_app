import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRecipe extends StatelessWidget {
  const CreateRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController timeCookingController = TextEditingController();
    final TextEditingController ratingController = TextEditingController();

    return WillPopScope(
      onWillPop: () async {
        // Clear input fields and image when user navigates back
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
                  controller: nameController,
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
                  controller: ratingController,
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
                  controller: timeCookingController,
                  decoration: InputDecoration(
                    label: const Text('Time Cooking'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
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
                const SizedBox(height: 16),

                // Use Consumer to show image or default text
                Consumer<FavouriteRecipeProvider>(
                  builder: (context, recipeProvider, child) {
                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Choose a photo'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Buttons to pick an image or capture one
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                              child: InkWell(
                                onTap: () => context
                                    .read<FavouriteRecipeProvider>()
                                    .pickImageFromGallery(),
                                child: Container(
                                  height: 200,
                                  width: 380,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: context
                                              .watch<FavouriteRecipeProvider>()
                                              .imageFile ==
                                          null
                                      ? const Center(
                                          child: Icon(Icons
                                              .add_photo_alternate_outlined)) // Placeholder text
                                      : Image.file(
                                          context
                                              .watch<FavouriteRecipeProvider>()
                                              .imageFile!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Button to save recipe
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BColors.accent,
                          ),
                          onPressed: () {
                            if (nameController.text.isNotEmpty &&
                                timeCookingController.text.isNotEmpty &&
                                ratingController.text.isNotEmpty) {
                              context
                                  .read<FavouriteRecipeProvider>()
                                  .addNewRecipe(
                                    nameController.text,
                                    descriptionController.text,
                                    timeCookingController.text,
                                    ratingController.text,
                                  );
                              Navigator.of(context)
                                  .pop(); // Return to the previous screen
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please fill all the text fields')),
                              );
                            }
                          },
                          child: const Text('Add New Recipe'),
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
  }
}
