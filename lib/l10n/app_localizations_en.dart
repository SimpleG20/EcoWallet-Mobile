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
  String get dashboardTotalBalance => 'Total Balance';

  @override
  String get dashboardIncome => 'Income';

  @override
  String get dashboardExpense => 'Expense';

  @override
  String get btnSave => 'Save Transaction';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get errorTitleEmpty => 'Please enter a title.';

  @override
  String get errorAmountInvalid => 'Please enter a valid amount.';
}
