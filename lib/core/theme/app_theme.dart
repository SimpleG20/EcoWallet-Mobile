import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'extra_colors.dart';

class AppTheme {
  // Private constructor
  const AppTheme._();

  // CSS: --radius: 0.75rem (~12px)
  static const double _radius = 12.0;

  // Font Weights from CSS
  static const FontWeight _fontNormal = FontWeight.w400;
  static const FontWeight _fontMedium = FontWeight.w500;

  /// Returns the Light Theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily:
          'Inter', // Assuming Inter as it's common with Tailwind defaults
      scaffoldBackgroundColor: AppColors.lightBackground,

      // Standard ColorScheme Mapping
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightPrimaryForeground,
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.lightSecondaryForeground,
        surface: AppColors.lightCard,
        onSurface: AppColors.lightCardForeground,
        error: AppColors.lightDestructive,
        onError: AppColors.lightDestructiveForeground,
        outline: AppColors.lightBorder,
        outlineVariant: AppColors.lightRing,
      ),

      // Input Decoration (Matches CSS input styles)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightInputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(
              color:
                  AppColors.lightInputBackground), // Transparent in CSS logic
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.lightRing, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
        margin: EdgeInsets.zero,
      ),

      // Typography Mapping (H1-H4 from CSS)
      textTheme: const TextTheme(
        displayLarge:
            TextStyle(fontSize: 24, fontWeight: _fontMedium, height: 1.5), // h1
        displayMedium:
            TextStyle(fontSize: 20, fontWeight: _fontMedium, height: 1.5), // h2
        displaySmall:
            TextStyle(fontSize: 18, fontWeight: _fontMedium, height: 1.5), // h3
        bodyLarge: TextStyle(
            fontSize: 16, fontWeight: _fontNormal, height: 1.5), // p/base
        labelLarge: TextStyle(
            fontSize: 16, fontWeight: _fontMedium, height: 1.5), // button/label
      ),

      // Extensions for custom properties
      extensions: [
        const ExtraColors(
          sidebar: AppColors.lightSidebar,
          sidebarForeground: AppColors.lightSidebarForeground,
          sidebarPrimary: AppColors.lightSidebarPrimary,
          sidebarPrimaryForeground: AppColors.lightSidebarPrimaryForeground,
          sidebarBorder: AppColors.lightBorder,
          ring: AppColors.lightRing,
          chart1: AppColors.chart1,
          chart2: AppColors.chart2,
          chart3: AppColors.chart3,
          chart4: AppColors.chart4,
          chart5: AppColors.chart5,
        ),
      ],
    );
  }

  /// Returns the Dark Theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkPrimaryForeground,
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.darkSecondaryForeground,
        surface: AppColors.darkCard,
        onSurface: AppColors.darkCardForeground,
        error: AppColors.darkDestructive,
        onError: AppColors.darkDestructiveForeground,
        outline: AppColors.darkBorder,
        outlineVariant: AppColors.darkRing,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor:
            AppColors.darkSecondary, // Used secondary for input in dark map
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.darkRing, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: _fontMedium,
            height: 1.5,
            color: AppColors.darkForeground),
        bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: _fontNormal,
            height: 1.5,
            color: AppColors.darkForeground),
      ),
      extensions: [
        const ExtraColors(
          sidebar: AppColors.darkSidebar,
          sidebarForeground: AppColors.darkSidebarForeground,
          sidebarPrimary: AppColors.darkSidebarPrimary,
          sidebarPrimaryForeground: AppColors.darkSidebarPrimaryForeground,
          sidebarBorder: AppColors.darkBorder,
          ring: AppColors.darkRing,
          // Charts might need slight adjustment for dark mode if desired,
          // reusing lights for now as per CSS implication.
          chart1: AppColors.chart1,
          chart2: AppColors.chart2,
          chart3: AppColors.chart3,
          chart4: AppColors.chart4,
          chart5: AppColors.chart5,
        ),
      ],
    );
  }
}
