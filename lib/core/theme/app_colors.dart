import 'package:flutter/material.dart';

import '../enums/enums.dart';

/// Defines the raw palette based on the provided CSS variables.
/// OKLCH values have been pre-converted to sRGB Color objects for performance.
class AppColors {
  // Private constructor to prevent instantiation
  const AppColors._();

  // --- Light Mode Palette ---
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightForeground = Color(0xFF1F2937);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardForeground = Color(0xFF1F2937);
  static const Color lightPrimary = Color(0xFF10B981);
  static const Color lightPrimaryForeground = Color(0xFFFFFFFF);
  static const Color lightSecondary = Color(0xFFF3F4F6);
  static const Color lightSecondaryForeground = Color(0xFF1F2937);
  static const Color lightMuted = Color(0xFFF3F4F6);
  static const Color lightMutedForeground = Color(0xFF6B7280);
  static const Color lightDestructive = Color(0xFFEF4444);
  static const Color lightDestructiveForeground = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0x1A000000); // rgba(0, 0, 0, 0.1)
  static const Color lightInputBackground = Color(0xFFF3F3F5);
  static const Color lightRing = Color(0xFFB4B4B4); // approx oklch(0.708 0 0)

  // --- Dark Mode Palette (Revitalized with subtle saturation) ---
  /// Deep dark background with subtle cool undertone for depth
  static const Color darkBackground = Color(0xFF121418);

  /// High contrast foreground for readability
  static const Color darkForeground = Color(0xFFF5F5F7);

  /// Card slightly elevated from background for visual hierarchy
  static const Color darkCard = Color(0xFF1C1E24);
  static const Color darkCardForeground = Color(0xFFF5F5F7);

  /// Primary green maintained for brand identity - vibrant emerald
  static const Color darkPrimary = Color(0xFF34D399);

  /// Dark foreground for contrast on primary buttons
  static const Color darkPrimaryForeground = Color(0xFF0D1117);

  /// Secondary with subtle blue undertone for modern feel
  static const Color darkSecondary = Color(0xFF2A2D36);
  static const Color darkSecondaryForeground = Color(0xFFF5F5F7);
  static const Color darkMuted = Color(0xFF2A2D36);

  /// Muted foreground with good contrast
  static const Color darkMutedForeground = Color(0xFF9CA3AF);

  /// Destructive red adapted for dark mode visibility
  static const Color darkDestructive = Color(0xFFEF4444);

  /// Light foreground for destructive buttons
  static const Color darkDestructiveForeground = Color(0xFFF5F5F7);

  /// Subtle border with cool undertone
  static const Color darkBorder = Color(0xFF2E3039);

  /// Ring color matching primary for focus states
  static const Color darkRing = Color(0xFF34D399);

  // --- Shared Accent Colors ---
  /// Primary green used for balance cards and positive indicators.
  static const Color primaryGreen = Color(0xFF10C085);

  // --- Eco Footprint Gradient (Light Mode) ---
  /// Dark green for eco footprint card gradient start.
  static const Color ecoGradientStart = Color(0xFF108E41);

  /// Light green for eco footprint card gradient end.
  static const Color ecoGradientEnd = Color(0xFF1BD386);

  // --- Eco Footprint Gradient (Dark Mode) ---
  /// Deeper green for dark mode eco footprint card gradient start.
  static const Color ecoGradientStartDark = Color(0xFF0A5C2A);

  /// Muted emerald for dark mode eco footprint card gradient end.
  static const Color ecoGradientEndDark = Color(0xFF10996B);

  // --- Charts (Shared or Specific) ---
  static const Color chart1 = Color(0xFF10B981);
  static const Color chart2 = Color(0xFF3B82F6);
  static const Color chart3 = Color(0xFFF59E0B);
  static const Color chart4 = Color(0xFF8B5CF6);
  static const Color chart5 = Color(0xFFEC4899);

  // --- Sidebar (Light) ---
  static const Color lightSidebar = Color(0xFFFAFAFA); // oklch(0.985 0 0)
  static const Color lightSidebarForeground = Color(0xFF242424); // oklch(0.145 0 0)
  static const Color lightSidebarPrimary = Color(0xFF030213);
  static const Color lightSidebarPrimaryForeground = Color(0xFFFAFAFA);

  // --- Sidebar (Dark) ---
  static const Color darkSidebar = Color(0xFF161920);
  static const Color darkSidebarForeground = Color(0xFFF5F5F7);
  static const Color darkSidebarPrimary = Color(0xFF34D399);
  static const Color darkSidebarPrimaryForeground = Color(0xFF0D1117);

  static Color getColorFromTransactionType(ETransactionType type) {
    switch (type) {
      case ETransactionType.income:
        return lightPrimary;
      case ETransactionType.expense:
        return lightDestructive;
    }
  }
}
