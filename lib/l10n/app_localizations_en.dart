// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'EcoWallet';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get dashboardTotalBalance => 'Total Balance';

  @override
  String get dashboardIncome => 'Income';

  @override
  String get dashboardExpense => 'Expense';

  @override
  String get dashboardRecentTransactions => 'Recent Transactions';

  @override
  String get dashboardMonthlySavings => 'Monthly Savings';

  @override
  String get dashboardNoTransactions => 'No transactions available.';

  @override
  String get btnSave => 'Save Transaction';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get btnViewAll => 'View All';

  @override
  String get btnHome => 'Home';

  @override
  String get btnWallet => 'Wallet';

  @override
  String get btnSettings => 'Settings';

  @override
  String get btnAnalytics => 'Analytics';

  @override
  String get btnProfile => 'Profile';

  @override
  String get lbUncategorized => 'Uncategorized';

  @override
  String get errorTitleEmpty => 'Please enter a title.';

  @override
  String get errorAmountInvalid => 'Please enter a valid amount.';

  @override
  String get errorAmountMustBePositive => 'Amount must be greater than zero.';

  @override
  String get errorAmountFormat =>
      'Invalid number format. Use only digits and a decimal separator.';
}
