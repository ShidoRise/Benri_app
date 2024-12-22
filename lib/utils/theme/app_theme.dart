import 'package:flutter/material.dart';
import 'package:benri_app/utils/constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: Brightness.light,
    primaryColor: BColors.primaryFirst,
    scaffoldBackgroundColor: BColors.white,

    // Colors
    colorScheme: ColorScheme.light(
      primary: BColors.primaryFirst,
      secondary: BColors.secondary,
      error: BColors.error,
      background: BColors.white,
      surface: BColors.white,
      secondaryFixed: BColors.black,
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: BColors.white,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: BColors.textPrimary),
      titleTextStyle: TextStyle(
        fontFamily: 'Nunito',
        color: BColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: BColors.textPrimary),
      headlineMedium: TextStyle(color: BColors.textPrimary),
      headlineSmall: TextStyle(color: BColors.textPrimary),
      bodyLarge: TextStyle(color: BColors.textPrimary),
      bodyMedium: TextStyle(color: BColors.textPrimary),
      bodySmall: TextStyle(color: BColors.textSecondary),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: BColors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // 2. Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: BColors.primaryFirst,
        foregroundColor: BColors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
    ),

    // 3. Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: BColors.white,
      selectedItemColor: BColors.primaryFirst,
      unselectedItemColor: BColors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // 4. Divider Theme
    dividerTheme: const DividerThemeData(
      color: BColors.borderPrimary,
      thickness: 1,
      space: 20,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: Brightness.dark,
    primaryColor: BColors.primaryFirst,
    scaffoldBackgroundColor: BColors.dark,

    // Colors
    colorScheme: ColorScheme.dark(
        primary: BColors.primaryFirst,
        secondary: BColors.secondary,
        error: BColors.error,
        background: BColors.dark,
        surface: BColors.grey,
        secondaryFixed: Colors.white),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: BColors.dark,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: BColors.white),
      titleTextStyle: const TextStyle(
        fontFamily: 'Nunito',
        color: BColors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: BColors.white),
      headlineMedium: TextStyle(color: BColors.white),
      headlineSmall: TextStyle(color: BColors.white),
      bodyLarge: TextStyle(color: BColors.white),
      bodyMedium: TextStyle(color: BColors.white),
      bodySmall: TextStyle(color: BColors.lightGrey),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: BColors.dark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // 2. Button Theme cho Dark mode
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: BColors.primaryFirst,
        foregroundColor: BColors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
    ),

    // 3. Bottom Navigation Bar Theme cho Dark mode
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: BColors.dark,
      selectedItemColor: BColors.primaryFirst,
      unselectedItemColor: BColors.darkGrey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // 4. Divider Theme cho Dark mode
    dividerTheme: DividerThemeData(
      color: BColors.darkGrey,
      thickness: 1,
      space: 20,
    ),
  );
}
