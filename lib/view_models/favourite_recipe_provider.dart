import 'package:benri_app/models/recipes/recipes.dart';
import 'package:flutter/material.dart';

class FavouriteRecipeProvider extends ChangeNotifier {
  final List<Recipes> _recipes = [
    Recipes(
        name: 'Grilled Pork Belly',
        description:
            'To make grilled pork belly, first marinate the pork with a mix of garlic, soy sauce, honey, black pepper, and sesame oil for at least 2 hours. Preheat the grill to medium-high heat. Place the pork belly slices on the grill, cooking each side for about 4-5 minutes or until golden brown and crispy. Use tongs to flip and baste with leftover marinade for extra flavor. Let it rest for a few minutes after grilling, then slice into bite-sized pieces. Serve with dipping sauces or alongside rice and vegetables for a delicious meal. Thank you for your watching, wait us more recipes',
        imgPath: 'assets/images/recipe/Grilled Pork Belly.png',
        rating: '4.9'),
    Recipes(
        name: 'Cơm Tấm',
        description:
            'Cơm tấm is a popular dish in southern Vietnam, particularly in Saigon (Ho Chi Minh City). It features broken rice grains, which were traditionally considered a lower-quality byproduct but have become a beloved base for this flavorful dish. Cơm tấm is usually served with a variety of toppings, including grilled pork (sườn nướng), shredded pork skin (bì), and steamed pork and egg patty (chả trứng). It’s typically garnished with pickled vegetables, cucumbers, and a fried egg. The dish is accompanied by a side of fish sauce (nước mắm) mixed with sugar, lime, and chili. Cơm tấm is a hearty meal with a delightful combination of textures and savory, sweet, and tangy flavors.',
        imgPath: 'assets/images/recipe/Com Tam.png',
        rating: '5.0'),
    Recipes(
        name: 'Phở Bò',
        description:
            'Phở is one of Vietnam’s most famous dishes, known for its aromatic broth and simple, yet flavorful ingredients. It consists of flat rice noodles (bánh phở) served in a savory broth made by simmering beef bones, herbs, and spices like star anise, cinnamon, and cloves for hours. Phở is typically topped with thin slices of beef (phở bò) or chicken (phở gà), and garnished with fresh herbs such as cilantro, Thai basil, and green onions. Bean sprouts, lime, and chili peppers are often served on the side, allowing diners to customize the flavor. A perfect balance of umami, sweetness, and fragrance, phở is enjoyed across Vietnam and has become beloved worldwide.',
        imgPath: 'assets/images/recipe/Pho.png',
        rating: '5.0'),
    Recipes(
        name: 'Bún Đậu Mắm Tôm',
        description:
            'Bún đậu mắm tôm is a traditional Vietnamese dish, primarily enjoyed in the northern regions. It consists of several key components: bún (rice vermicelli noodles), đậu (fried tofu), and mắm tôm (fermented shrimp paste). Often, the dish is served with additional toppings like boiled pork belly, Vietnamese herbs, and sometimes chả cốm (fried green rice cakes). The shrimp paste, mắm tôm, is mixed with lime, sugar, and chili, creating a pungent yet flavorful dipping sauce. While the aroma of mắm tôm can be intense, it’s beloved by locals for its unique taste. Bún đậu mắm tôm is typically enjoyed as a light meal or street food, with a bold mix of textures and flavors.',
        imgPath: 'assets/images/recipe/Bun Dau.png',
        rating: '5.0'),
    Recipes(
        name: 'Pasta',
        description:
            'Pasta is a beloved dish that originated in Italy but has become a global favorite. Made primarily from wheat flour and water, pasta comes in various shapes and sizes, such as spaghetti, penne, fettuccine, and ravioli. It is incredibly versatile and pairs well with a wide range of sauces, from the classic tomato-based marinara to creamy Alfredo or rich pesto. Pasta can be served with a variety of ingredients, including vegetables, meats, seafood, and cheeses, making it adaptable for different palates. Whether baked as lasagna, served cold in a salad, or simply topped with olive oil and garlic, pasta remains a comforting, satisfying, and universally enjoyed meal.',
        imgPath: 'assets/images/recipe/Pasta.png',
        rating: '4.8'),
    Recipes(
        name: 'Salad',
        description:
            'Salad is a diverse dish made primarily from raw or cooked vegetables, often combined with fruits, grains, proteins, and a variety of dressings. Popular as a healthy meal option, salads can range from simple combinations like lettuce, tomatoes, and cucumbers to more elaborate creations with ingredients such as avocados, nuts, cheese, or grilled meats. Dressings, like vinaigrettes or creamy sauces, enhance the flavor and texture of the salad. Some well-known types of salads include Caesar salad, Greek salad, and Cobb salad. Whether served as a side dish or a main course, salads offer endless possibilities and are celebrated for their freshness, nutritional benefits, and adaptability to different tastes and dietary preferences.',
        imgPath: 'assets/images/recipe/Salad.png',
        rating: '4.8'),
    Recipes(
        name: 'Pizza',
        description:
            'Pizza, originally from Italy, has become one of the world’s most popular and beloved dishes. It consists of a flatbread base topped with tomato sauce, cheese, and a wide variety of ingredients such as vegetables, meats, and seafood. The dough is typically made from wheat flour, and the cheese most commonly used is mozzarella, though other varieties can be added. Classic pizza types include Margherita, featuring basil, mozzarella, and tomato, and pepperoni, topped with spicy sausage slices. Whether cooked in a wood-fired oven or a modern pizza oven, the crispy crust, melted cheese, and rich toppings make pizza a flavorful and satisfying meal. Its versatility allows for endless creative variations, appealing to diverse tastes worldwide.',
        imgPath: 'assets/images/recipe/Pizza.png',
        rating: '4.8'),
  ];

  final List<Recipes> _favouriteRecipes = [];

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
