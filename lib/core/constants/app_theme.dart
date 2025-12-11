import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application theme configuration
class AppTheme {
  AppTheme._();

  // Colors
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color secondaryColor = Color(0xFF8BC34A);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFE57373);
  static const Color successColor = Color(0xFF66BB6A);

  // Light theme colors
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Colors.white;
  static const Color lightOnBackground = Color(0xFF212121);
  static const Color lightOnSurface = Color(0xFF424242);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnBackground = Color(0xFFE0E0E0);
  static const Color darkOnSurface = Color(0xFFB0B0B0);

  /// Light theme
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: lightSurface,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightOnSurface,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: lightBackground,
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          color: lightOnBackground,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          color: lightOnBackground,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: textTheme.displaySmall?.copyWith(
          color: lightOnBackground,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          color: lightOnBackground,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          color: lightOnBackground,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: lightOnSurface,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: lightOnSurface,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: lightOnBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: lightOnBackground,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
      ),
    );
  }

  /// Dark theme
  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: darkSurface,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkOnSurface,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          color: darkOnBackground,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          color: darkOnBackground,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: textTheme.displaySmall?.copyWith(
          color: darkOnBackground,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          color: darkOnBackground,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          color: darkOnBackground,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: darkOnSurface,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: darkOnSurface,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkOnBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: darkOnBackground,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
      ),
    );
  }
}
