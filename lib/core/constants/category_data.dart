import 'package:flutter/material.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';

import '../enums/enums.dart';

/// Model class containing the display information for a category.
class CategoryDisplayInfo {
  final IconData icon;
  final String Function(AppLocalizations loc) labelBuilder;

  const CategoryDisplayInfo({
    required this.icon,
    required this.labelBuilder,
  });

  /// Gets the localized label for this category.
  String getLabel(AppLocalizations loc) => labelBuilder(loc);
}

/// Centralized repository for all category-related data.
/// This is the single source of truth for categories in the app.
abstract class CategoryRepository {
  /// Map of all categories with their display information.
  static const Map<ETransactionCategory, CategoryDisplayInfo> _categories = {
    ETransactionCategory.food: CategoryDisplayInfo(
      icon: Icons.fastfood_outlined,
      labelBuilder: _getLabelFood,
    ),
    ETransactionCategory.transport: CategoryDisplayInfo(
      icon: Icons.directions_car_outlined,
      labelBuilder: _getLabelTransport,
    ),
    ETransactionCategory.bills: CategoryDisplayInfo(
      icon: Icons.home_work_outlined,
      labelBuilder: _getLabelBills,
    ),
    ETransactionCategory.health: CategoryDisplayInfo(
      icon: Icons.health_and_safety_outlined,
      labelBuilder: _getLabelHealth,
    ),
    ETransactionCategory.shopping: CategoryDisplayInfo(
      icon: Icons.shopping_cart_outlined,
      labelBuilder: _getLabelShopping,
    ),
    ETransactionCategory.entertainment: CategoryDisplayInfo(
      icon: Icons.movie_outlined,
      labelBuilder: _getLabelEntertainment,
    ),
    ETransactionCategory.salary: CategoryDisplayInfo(
      icon: Icons.money_outlined,
      labelBuilder: _getLabelSalary,
    ),
    ETransactionCategory.others: CategoryDisplayInfo(
      icon: Icons.miscellaneous_services_outlined,
      labelBuilder: _getLabelOthers,
    ),
  };

  // Label builder functions (required for const Map).
  static String _getLabelFood(AppLocalizations loc) => loc.lbFood;
  static String _getLabelTransport(AppLocalizations loc) => loc.lbTransport;
  static String _getLabelBills(AppLocalizations loc) => loc.lbBills;
  static String _getLabelHealth(AppLocalizations loc) => loc.lbHealth;
  static String _getLabelShopping(AppLocalizations loc) => loc.lbShopping;
  static String _getLabelEntertainment(AppLocalizations loc) => loc.lbEntertainment;
  static String _getLabelSalary(AppLocalizations loc) => loc.lbSalary;
  static String _getLabelOthers(AppLocalizations loc) => loc.lbOthers;

  /// Returns all available categories.
  static List<ETransactionCategory> get allCategories => ETransactionCategory.values;

  /// Returns the number of available categories.
  static int get categoryCount => ETransactionCategory.values.length;

  /// Gets the display info for a category.
  static CategoryDisplayInfo getDisplayInfo(ETransactionCategory category) {
    return _categories[category]!;
  }

  /// Gets the icon for a category.
  static IconData getIcon(ETransactionCategory category) {
    return _categories[category]!.icon;
  }

  /// Gets the localized label for a category.
  static String getLabel(ETransactionCategory category, AppLocalizations loc) {
    return _categories[category]!.getLabel(loc);
  }

  /// Gets a category by its index in the enum.
  static ETransactionCategory getCategoryByIndex(int index) {
    return ETransactionCategory.values[index];
  }

  /// Tries to find a category by its localized label.
  /// Returns null if no match is found.
  static ETransactionCategory? getCategoryByLabel(String label, AppLocalizations loc) {
    for (final category in ETransactionCategory.values) {
      if (getLabel(category, loc) == label) {
        return category;
      }
    }
    return null;
  }

  /// Gets the icon for a category label string.
  /// Falls back to a default icon if the category is not found.
  static IconData getIconByLabel(String label, AppLocalizations loc) {
    final category = getCategoryByLabel(label, loc);
    if (category != null) {
      return getIcon(category);
    }
    return Icons.category;
  }

  /// Checks if the given label corresponds to the "Others" category.
  static bool isOthersCategory(String label, AppLocalizations loc) {
    return label == getLabel(ETransactionCategory.others, loc);
  }

  static ETransactionCategory fromLabel(String cat, AppLocalizations loc) {
    var labels = ETransactionCategory.values.map((e) => getLabel(e, loc)).toList();

    var index = labels.indexOf(cat);
    if (index == -1) {
      return ETransactionCategory.others;
    }
    return ETransactionCategory.values[index];
  }
}
