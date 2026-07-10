import 'package:eco_wallet/features/settings/domain/enums/font_size_preference.dart';
import 'package:flutter/material.dart';
import 'package:eco_wallet/features/settings/domain/enums/color_blind_mode.dart';
import 'package:eco_wallet/core/theme/app_colors.dart';
import 'package:eco_wallet/core/theme/extra_colors.dart';

class AppTheme {
  // Private constructor
  const AppTheme._();

  // CSS: --radius: 0.75rem (~12px)
  static const double _radius = 12.0;

  // Font Weights from CSS
  static const FontWeight _fontNormal = FontWeight.w400;
  static const FontWeight _fontMedium = FontWeight.w500;
  static const FontWeight _fontSemiBold = FontWeight.w600;
  static const FontWeight _fontBold = FontWeight.w700;

  static double getTextScaleFactor(FontSizePreference fontSize) {
    switch (fontSize) {
      case FontSizePreference.small:
        return 0.85;
      case FontSizePreference.medium:
        return 1.0;
      case FontSizePreference.large:
        return 1.15;
    }
  }

  /// Returns the Light Theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Inter', // Assuming Inter as it's common with Tailwind defaults
      scaffoldBackgroundColor: AppColors.lightBackground,

      // Standard ColorScheme Mapping
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightPrimaryForeground,
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.lightSecondaryForeground,
        surface: AppColors.lightCard,
        onSurface: AppColors.lightCardForeground,
        onSurfaceVariant: AppColors.lightMutedForeground,
        onInverseSurface: AppColors.lightBackground,
        error: AppColors.lightDestructive,
        onError: AppColors.lightDestructiveForeground,
        outline: AppColors.lightBorder,
        outlineVariant: AppColors.lightRing,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightPrimaryForeground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: _fontSemiBold,
          color: AppColors.lightPrimaryForeground,
        ),
      ),

      // Input Decoration (Matches CSS input styles)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightInputBackground,
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: _fontMedium,
          height: 1.5,
          color: AppColors.lightForeground.withAlpha(120),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.lightInputBackground), // Transparent in CSS logic
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.lightRing, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightPrimaryForeground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        ),
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
        titleLarge: TextStyle(fontSize: 22, fontWeight: _fontSemiBold, height: 1.5), // h4
        titleMedium: TextStyle(fontSize: 18, fontWeight: _fontSemiBold, height: 1.5), // h5
        titleSmall: TextStyle(fontSize: 16, fontWeight: _fontMedium, height: 1.5), // h6
        displayLarge: TextStyle(fontSize: 24, fontWeight: _fontSemiBold, height: 1.5), // h1
        displayMedium: TextStyle(fontSize: 20, fontWeight: _fontSemiBold, height: 1.5), // h2
        displaySmall: TextStyle(fontSize: 18, fontWeight: _fontMedium, height: 1.5), // h3
        bodyLarge: TextStyle(fontSize: 16, fontWeight: _fontNormal, height: 1.5), // p/base
        labelLarge: TextStyle(fontSize: 16, fontWeight: _fontBold, height: 1.5), // button/label
      ),

      snackBarTheme: SnackBarThemeData(
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        contentTextStyle: const TextStyle(
          fontSize: 15,
          fontWeight: _fontSemiBold,
          color: AppColors.lightPrimaryForeground,
        ),
        actionTextColor: AppColors.lightPrimaryForeground,
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
        onSurfaceVariant: AppColors.darkMutedForeground,
        onInverseSurface: AppColors.darkBackground,
        error: AppColors.darkDestructive,
        onError: AppColors.darkDestructiveForeground,
        outline: AppColors.darkBorder,
        outlineVariant: AppColors.darkRing,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkPrimaryForeground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: _fontSemiBold,
          color: AppColors.darkPrimaryForeground,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSecondary,
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: _fontMedium,
          height: 1.5,
          color: AppColors.darkMutedForeground,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.darkRing, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkPrimaryForeground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
        margin: EdgeInsets.zero,
      ),
      // Complete TextTheme matching light theme structure
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 22, fontWeight: _fontSemiBold, height: 1.5, color: AppColors.darkForeground),
        titleMedium: TextStyle(fontSize: 18, fontWeight: _fontSemiBold, height: 1.5, color: AppColors.darkForeground),
        titleSmall: TextStyle(fontSize: 16, fontWeight: _fontMedium, height: 1.5, color: AppColors.darkForeground),
        displayLarge: TextStyle(fontSize: 24, fontWeight: _fontSemiBold, height: 1.5, color: AppColors.darkForeground),
        displayMedium: TextStyle(fontSize: 20, fontWeight: _fontSemiBold, height: 1.5, color: AppColors.darkForeground),
        displaySmall: TextStyle(fontSize: 18, fontWeight: _fontMedium, height: 1.5, color: AppColors.darkForeground),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: _fontNormal, height: 1.5, color: AppColors.darkForeground),
        labelLarge: TextStyle(fontSize: 16, fontWeight: _fontBold, height: 1.5, color: AppColors.darkForeground),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkCard,
        showCloseIcon: true,
        closeIconColor: AppColors.darkForeground,
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        contentTextStyle: const TextStyle(
          fontSize: 15,
          fontWeight: _fontSemiBold,
          color: AppColors.darkForeground,
        ),
        actionTextColor: AppColors.darkPrimary,
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

  static ColorFilter getColorFilter(ColorBlindMode mode) {
    switch (mode) {
      case ColorBlindMode.none:
        return const ColorFilter.matrix(<double>[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
      case ColorBlindMode.protanopia:
        return const ColorFilter.matrix(
            <double>[0.567, 0.433, 0, 0, 0, 0.558, 0.442, 0, 0, 0, 0, 0.242, 0.758, 0, 0, 0, 0, 0, 1, 0]);
      case ColorBlindMode.deuteranopia:
        return const ColorFilter.matrix(
            <double>[0.625, 0.375, 0, 0, 0, 0.7, 0.3, 0, 0, 0, 0, 0.3, 0.7, 0, 0, 0, 0, 0, 1, 0]);
      case ColorBlindMode.tritanopia:
        return const ColorFilter.matrix(
            <double>[0.95, 0.05, 0, 0, 0, 0, 0.433, 0.567, 0, 0, 0, 0.475, 0.525, 0, 0, 0, 0, 0, 1, 0]);
    }
  }
}
