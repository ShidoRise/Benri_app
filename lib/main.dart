import 'package:benri_app/models/ingredients/ingredients.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/views/screens/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized

  await Hive.initFlutter();
  Hive.registerAdapter(
      IngredientAdapter()); // Register the TypeAdapter for Ingredient

  await Hive.openBox('mybox'); // Open Hive box

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BasketViewModel()),
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
      ),
      home: const NavigationMenu(), // Entry point of the app
    );
  }
}
