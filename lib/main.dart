import 'package:benri_app/models/baskets/baskets.dart';
import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/models/ingredients/basket_ingredients.dart';
import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/view_models/fridge_screen_provider.dart';
import 'package:benri_app/views/screens/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'view_models/drawer_provider.dart';
import 'view_models/ingredient_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(BasketIngredientAdapter());
  Hive.registerAdapter(BasketAdapter());
  Hive.registerAdapter(IngredientSuggestionAdapter());
  Hive.registerAdapter(FridgeIngredientAdapter());
  Hive.registerAdapter(RecipesAdapter());

  await Hive.openBox('fridgeIngredientBox');
  await Hive.openBox<Basket>('basketBox');
  await Hive.openBox('ingredientSuggestionsBox');
  await Hive.openBox('recipeBox');
  await Hive.openBox('drawerBox');

  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BasketViewModel()),
        ChangeNotifierProvider(
          create: (context) => DrawerProvider(),
        ),
        ChangeNotifierProvider(create: (context) => IngredientProvider()),
        ChangeNotifierProvider(create: (context) => FridgeScreenProvider()),
        ChangeNotifierProvider(create: (context) => FavouriteRecipeProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: BColors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: BColors.darkGrey,
        ),
      ),
      home: const NavigationMenu(),
    );
  }
}
