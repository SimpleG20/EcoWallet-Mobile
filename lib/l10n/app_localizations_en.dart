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
  String get addTransaction => 'Add Transaction';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get dashboardTotalBalance => 'Total Balance';

  @override
  String get dashboardRecentTransactions => 'Recent Transactions';

  @override
  String get dashboardMonthlySavings => 'Monthly Savings';

  @override
  String get dashboardNoTransactions => 'No transactions available.';

  @override
  String get searchTransactions => 'Search transactions...';

  @override
  String get btnUndo => 'Undo';

  @override
  String get btnRedo => 'Redo';

  @override
  String get btnSave => 'Save Transaction';

  @override
  String get btnViewAll => 'View All';

  @override
  String get lbName => 'Name';

  @override
  String get lbDate => 'Date';

  @override
  String get lbHome => 'Home';

  @override
  String get lbFood => 'Food';

  @override
  String get lbBills => 'Bills';

  @override
  String get lbWallet => 'Wallet';

  @override
  String get lbCancel => 'Cancel';

  @override
  String get lbIncome => 'Income';

  @override
  String get lbSalary => 'Salary';

  @override
  String get lbHealth => 'Health';

  @override
  String get lbOthers => 'Others';

  @override
  String get lbAmount => 'Amount';

  @override
  String get lbProfile => 'Profile';

  @override
  String get lbExpense => 'Expense';

  @override
  String get lbSettings => 'Settings';

  @override
  String get lbShopping => 'Shopping';

  @override
  String get lbCategory => 'Category';

  @override
  String get lbAnalytics => 'Analytics';

  @override
  String get lbTransport => 'Transport';

  @override
  String get lbUncategorized => 'Uncategorized';

  @override
  String get lbEntertainment => 'Entertainment';

  @override
  String get lbAllTransactions => 'All Transactions';

  @override
  String get formNameHint => 'Enter transaction name';

  @override
  String get formCategoryHint => 'Write the category';

  @override
  String get msgTransactionAdded => 'Transaction added successfully.';

  @override
  String get msgTransactionUpdated => 'Transaction updated successfully.';

  @override
  String get msgTransactionDeleted => 'Transaction deleted successfully.';

  @override
  String get errorAmountEmpty => 'Please enter an amount.';

  @override
  String get errorCategoryEmpty => 'Please select a category.';

  @override
  String get errorDateEmpty => 'Please select a date.';

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
