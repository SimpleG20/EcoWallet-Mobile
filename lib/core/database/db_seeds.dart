import 'package:sqflite/sqflite.dart';

/// Seeds lookup tables with initial data.
/// This class is used during database creation and migration.
class DbSeeds {
  /// Seeds the transaction_types table with income and expense types.
  static Future<void> seedTransactionTypes(Database db) async {
    await db.insert('transaction_types', {'id': 1, 'name': 'income'},
        conflictAlgorithm: ConflictAlgorithm.ignore);
    await db.insert('transaction_types', {'id': 2, 'name': 'expense'},
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  /// Seeds the categories table with all predefined categories.
  static Future<void> seedCategories(Database db) async {
    final categories = [
      {'id': 1, 'name': 'food', 'icon_name': 'fastfood_outlined'},
      {'id': 2, 'name': 'transport', 'icon_name': 'directions_car_outlined'},
      {'id': 3, 'name': 'bills', 'icon_name': 'home_work_outlined'},
      {'id': 4, 'name': 'health', 'icon_name': 'health_and_safety_outlined'},
      {'id': 5, 'name': 'shopping', 'icon_name': 'shopping_cart_outlined'},
      {'id': 6, 'name': 'entertainment', 'icon_name': 'movie_outlined'},
      {'id': 7, 'name': 'salary', 'icon_name': 'money_outlined'},
      {'id': 8, 'name': 'others', 'icon_name': 'miscellaneous_services_outlined'},
    ];

    for (final category in categories) {
      await db.insert('categories', category,
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  /// Seeds all lookup tables.
  static Future<void> seedAll(Database db) async {
    await seedTransactionTypes(db);
    await seedCategories(db);
  }

  /// Maps a category name string to its corresponding ID.
  static int getCategoryId(String categoryName) {
    const categoryMap = {
      'food': 1,
      'transport': 2,
      'bills': 3,
      'health': 4,
      'shopping': 5,
      'entertainment': 6,
      'salary': 7,
      'others': 8,
    };
    return categoryMap[categoryName.toLowerCase()] ?? 8; // Default to 'others'
  }

  /// Maps a transaction type name to its corresponding ID.
  static int getTypeId(String typeName) {
    return typeName.toLowerCase() == 'income' ? 1 : 2;
  }

  /// Maps a category ID to its name.
  static String getCategoryName(int id) {
    const idMap = {
      1: 'food',
      2: 'transport',
      3: 'bills',
      4: 'health',
      5: 'shopping',
      6: 'entertainment',
      7: 'salary',
      8: 'others',
    };
    return idMap[id] ?? 'others';
  }

  /// Maps a transaction type ID to its name.
  static String getTypeName(int id) {
    return id == 1 ? 'income' : 'expense';
  }
}
