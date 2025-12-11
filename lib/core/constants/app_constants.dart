/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'EcoWallet';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String dbName = 'ecowallet.db';
  static const int dbVersion = 1;
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  
  // Date Limits
  static final DateTime earliestDate = DateTime(2000);
  static final DateTime latestDate = DateTime.now();
  
  // Transaction Categories
  static const List<String> expenseCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Travel',
    'Others',
  ];
  
  static const List<String> incomeCategories = [
    'Salary',
    'Business',
    'Investment',
    'Gift',
    'Others',
  ];
  
  // Limits
  static const int maxTransactionDescriptionLength = 200;
  static const int maxCategoryNameLength = 50;
}
