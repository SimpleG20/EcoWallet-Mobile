import 'package:flutter/material.dart';

import '../constants/transaction_type_data.dart';

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

  // --- Dark Mode Palette (Converted from OKLCH) ---
  // oklch(0.145 0 0) -> #242424
  static const Color darkBackground = Color(0xFF242424);
  // oklch(0.985 0 0) -> #FAFAFA
  static const Color darkForeground = Color(0xFFFAFAFA);
  // oklch(0.145 0 0) -> #242424
  static const Color darkCard = Color(0xFF242424);
  static const Color darkCardForeground = Color(0xFFFAFAFA);
  // oklch(0.985 0 0) -> #FAFAFA
  static const Color darkPrimary = Color(0xFFFAFAFA);
  // oklch(0.205 0 0) -> #333333
  static const Color darkPrimaryForeground = Color(0xFF333333);
  // oklch(0.269 0 0) -> #454545
  static const Color darkSecondary = Color(0xFF454545);
  static const Color darkSecondaryForeground = Color(0xFFFAFAFA);
  static const Color darkMuted = Color(0xFF454545);
  // oklch(0.708 0 0) -> #B4B4B4
  static const Color darkMutedForeground = Color(0xFFB4B4B4);
  // oklch(0.396 0.141 25.723) -> #993333 (Approx Red)
  static const Color darkDestructive = Color(0xFF993333);
  // oklch(0.637 0.237 25.331) -> #FF6666 (Approx Lighter Red)
  static const Color darkDestructiveForeground = Color(0xFFFF6666);
  static const Color darkBorder = Color(0xFF454545);
  static const Color darkRing = Color(0xFF6E6E6E); // approx oklch(0.439 0 0)

  // --- Shared Accent Colors ---
  /// Primary green used for balance cards and positive indicators.
  static const Color primaryGreen = Color(0xFF10C085);

  // --- Charts (Shared or Specific) ---
  static const Color chart1 = Color(0xFF10B981);
  static const Color chart2 = Color(0xFF3B82F6);
  static const Color chart3 = Color(0xFFF59E0B);
  static const Color chart4 = Color(0xFF8B5CF6);
  static const Color chart5 = Color(0xFFEC4899);

  // --- Sidebar (Light) ---
  static const Color lightSidebar = Color(0xFFFAFAFA); // oklch(0.985 0 0)
  static const Color lightSidebarForeground =
      Color(0xFF242424); // oklch(0.145 0 0)
  static const Color lightSidebarPrimary = Color(0xFF030213);
  static const Color lightSidebarPrimaryForeground = Color(0xFFFAFAFA);

  // --- Sidebar (Dark) ---
  static const Color darkSidebar = Color(0xFF333333); // oklch(0.205 0 0)
  static const Color darkSidebarForeground = Color(0xFFFAFAFA);
  static const Color darkSidebarPrimary =
      Color(0xFF4ADE80); // Adjusted for visibility
  static const Color darkSidebarPrimaryForeground = Color(0xFFFAFAFA);

  static Color getColorFromTransactionType(ETransactionType type) {
    switch (type) {
      case ETransactionType.income:
        return lightPrimary;
      case ETransactionType.expense:
        return lightDestructive;
      case ETransactionType.reserve:
        return chart4;
    }
  }
}
