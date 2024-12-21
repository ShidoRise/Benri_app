import 'dart:io';
import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/views/screens/recipe_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/services/recipes_service.dart';

class FavouriteRecipeProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  List<Recipes> _recipes = [];
  List<Recipes> favouriteRecipes = [];
  List<Recipes> filterRecipes = [];
  List<String> categories = [];
  String? selectedCategory = "Tất cả";

  File? _imageFile;
  final _picker = ImagePicker();

  List<Recipes> get recipes => _recipes;
  File? get imageFile => _imageFile;

  bool _isShowAll = false;
  bool get isShowAll => _isShowAll;

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  void toggleShowAll() {
    _isShowAll = !_isShowAll;
    notifyListeners();
  }

  FavouriteRecipeProvider() {
    initializeData();
  }

  Future<void> initializeData() async {
    // Add default recipes to service
    await fetchData();

    // Fetch data from db
    await fetchDataFromDb();

    notifyListeners();
  }

  Future<void> fetchDataFromDb() async {
    favouriteRecipes = await RecipesService.getAllFavouriteRecipes();
    print("favouriteRecipes :: $favouriteRecipes");
  }

  Future<void> deleteFromFavourite(Recipes recipe) async {
    await RecipesService.deleteFromFavourite(recipe);
    print(_recipes);
    favouriteRecipes.remove(recipe);
    notifyListeners();
  }

  Future<void> fetchData() async {
    _recipes = await RecipesService.fetchData();
    print('OKKK ${_recipes.length}');
    categories = await RecipesService.fetchCategories();
    categories = ["Tất cả", ...categories];
  }

  Future<List<Recipes>> getAllRecipes() async {
    final serviceRecipes = await RecipesService.getAllRecipes();
    return [
      ..._recipes,
      ...serviceRecipes
          .where((r) => !_recipes.any((local) => local.name == r.name))
    ];
  }

  Future<void> addNewRecipe(String name, String description, String timeCooking,
      String rating, List<FridgeIngredient> ingredients) async {
    final newRecipe = Recipes(
      name: name,
      description: description,
      imgPath: _imageFile?.path ?? 'assets/images/ingredient/default.png',
      rating: rating,
      timeCooking: timeCooking,
      ingredients: ingredients,
    );
    await RecipesService.addRecipe(newRecipe);
    _imageFile = null;
    notifyListeners();
  }

  Future<void> removeRecipe(Recipes recipe) async {
    await RecipesService.removeRecipe(recipe);
    notifyListeners();
  }

  Future<void> updateRecipe(Recipes recipe) async {
    notifyListeners();
  }

  Future<void> navigateToRecipeDetails(
      BuildContext context, Recipes recipe) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  // Image handling methods
  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> captureImageWithCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  void clearImageFile() {
    _imageFile = null;
    notifyListeners();
  }

  void toggleFavourite(Recipes recipe) async {
    // Cập nhật UI ngay lập tức
    recipe.isFavorite = !recipe.isFavorite;

    if (recipe.isFavorite) {
      favouriteRecipes.add(recipe);
    } else {
      favouriteRecipes.remove(recipe);
    }
    notifyListeners();

    await RecipesService.toggleFavorite(recipe);
  }

  void filterByCategory(String category) {
    if (selectedCategory == category) {
      selectedCategory = null;
    } else {
      selectedCategory = category;
      filterRecipes = getFilteredRecipes(recipes);
    }
    notifyListeners();
  }

  List<Recipes> getFilteredRecipes(List<Recipes> recipes) {
    return recipes.where((recipe) {
      final matchesCategory =
          selectedCategory == 'Tất cả' || recipe.category == selectedCategory;
      final matchesSearch = recipe.name.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void searchRecipes(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
