import 'package:benri_app/models/baskets/baskets.dart';
import 'package:benri_app/models/fridge_drawers/fridge_drawers.dart';
import 'package:benri_app/models/ingredients/fridge_ingredients.dart';
import 'package:benri_app/models/ingredients/ingredient_suggestions.dart';
import 'package:benri_app/models/ingredients/basket_ingredients.dart';
import 'package:benri_app/models/recipes/recipes.dart';
import 'package:benri_app/services/user_local.dart';
import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/utils/theme/app_theme.dart';
import 'package:benri_app/view_models/favourite_recipe_provider.dart';
import 'package:benri_app/view_models/fridge_screen_provider.dart';
import 'package:benri_app/view_models/profile_viewmodel.dart';
import 'package:benri_app/view_models/review_viewmodel.dart';
import 'package:benri_app/view_models/theme_provider.dart';
import 'package:benri_app/views/screens/navigation_menu.dart';
import 'package:benri_app/views/screens/onboarding_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:benri_app/view_models/basket_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view_models/drawer_provider.dart';
import 'view_models/ingredient_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  _showNotification(message.notification?.title, message.notification?.body);
}

void _handleForegroundMessage(RemoteMessage message) {
  _showNotification(message.notification?.title, message.notification?.body);
}

Future<void> _showNotification(String? title, String? body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'abcxyz',
    'duydeptrai',
    channelDescription: 'duy code',
    importance: Importance.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  try {
    await flutterLocalNotificationsPlugin.show(
      1111,
      title ?? '',
      body ?? '',
      platformChannelSpecifics,
      payload: 'item x',
    );
  } catch (e) {
    print("Error showing notification: $e");
  }
  print('222222');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  //Config FB
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Hive.initFlutter();
  Hive.registerAdapter(BasketIngredientAdapter());
  Hive.registerAdapter(BasketAdapter());
  Hive.registerAdapter(IngredientSuggestionAdapter());
  Hive.registerAdapter(FridgeIngredientAdapter());
  Hive.registerAdapter(RecipesAdapter());
  Hive.registerAdapter(FridgeDrawerAdapter());

  await Hive.openBox('fridgeIngredientBox');
  await Hive.openBox<Basket>('basketBox');
  await Hive.openBox<IngredientSuggestion>('ingredientSuggestionsBox');
  await Hive.openBox<Recipes>('recipeBox');
  await Hive.openBox<FridgeDrawer>('fridgeDrawerBox');
  await Hive.openBox<bool>('favoriteBox');

  await dotenv.load(fileName: ".env");
  Map<String, String> userInfo = await UserLocal.getUserInfo();
  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool('onboarding') ?? false;

  prefs.setBool('isDarkMode', false);
  runApp(
    MyApp(onboarding: onboarding),
  );
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp({super.key, this.onboarding = false});
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BasketViewModel()),
        ChangeNotifierProvider(create: (_) => IngredientProvider()),
        ChangeNotifierProvider(create: (_) => FridgeScreenProvider()),
        ChangeNotifierProvider(create: (_) => FavouriteRecipeProvider()),
        ChangeNotifierProvider(create: (_) => DrawerProvider()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Benri App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: onboarding ? const NavigationMenu() : const OnboardingView(),
          );
        },
      ),
    );
  }
}
