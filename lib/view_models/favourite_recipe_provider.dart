import 'package:benri_app/models/recipes/recipes.dart';
import 'package:flutter/material.dart';

class FavouriteRecipeProvider extends ChangeNotifier {
  final List<Recipes> _recipes = [
    Recipes(
        name: 'Grilled Pork Belly',
        description: '',
        imgPath: 'assets/images/ingredient/Pork Belly.png',
        rating: '4.9'),
    Recipes(
        name: 'Grilled Pork Belly',
        description: '',
        imgPath: 'assets/images/ingredient/Pork Belly.png',
        rating: '4.9'),
    Recipes(
        name: 'Grilled Pork Belly',
        description: '',
        imgPath: 'assets/images/ingredient/Pork Belly.png',
        rating: '4.9'),
  ];

  List<Recipes> _favouriteRecipes = [];

  List<Recipes> get recipes => _recipes;
  List<Recipes> get favouriteRecipes => _favouriteRecipes;

  void addToFavourite(Recipes recipe) {
    _favouriteRecipes.add(recipe);
    notifyListeners();
  }

  void removeFromFavourite(Recipes recipe) {
    _favouriteRecipes.remove(recipe);
    notifyListeners();
  }
}
