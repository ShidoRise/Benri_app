import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/models/ingredients/ingredients.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/view_models/fridge_screen_provider.dart';
import 'package:benri_app/views/screens/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'view_models/drawer_provider.dart';
import 'view_models/ingredient_provider.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized

  await Hive.initFlutter();
  Hive.registerAdapter(IngredientAdapter());

  Hive.registerAdapter(IngredientSuggestionAdapter());

  await Hive.openBox('basketBox');
  await Hive.openBox('ingredientSuggestionsBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BasketViewModel()),
        ChangeNotifierProvider(
            create: (context) => DrawerProvider()), // Drawer state
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
        colorScheme: ColorScheme.light(),
      ),
      home: const NavigationMenu(), // Entry point of the app
    );
  }
}
