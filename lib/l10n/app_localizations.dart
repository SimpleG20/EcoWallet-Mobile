import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'EcoWallet'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransaction;

  /// No description provided for @dashboardTotalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get dashboardTotalBalance;

  /// No description provided for @dashboardMonthlySavings.
  ///
  /// In en, this message translates to:
  /// **'Monthly Savings'**
  String get dashboardMonthlySavings;

  /// No description provided for @dashboardWeeklyOverview.
  ///
  /// In en, this message translates to:
  /// **'Weekly Overview'**
  String get dashboardWeeklyOverview;

  /// No description provided for @dashboardRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get dashboardRecentTransactions;

  /// No description provided for @dashboardNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions available.'**
  String get dashboardNoTransactions;

  /// No description provided for @dashboardWeeklyOverviewInfo.
  ///
  /// In en, this message translates to:
  /// **'Shows weekly transaction overview.\nThe rightmost bar represents today.'**
  String get dashboardWeeklyOverviewInfo;

  /// No description provided for @askForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get askForgotPassword;

  /// No description provided for @searchTransactions.
  ///
  /// In en, this message translates to:
  /// **'Search transactions...'**
  String get searchTransactions;

  /// No description provided for @filterTransactions.
  ///
  /// In en, this message translates to:
  /// **'Filter Transactions'**
  String get filterTransactions;

  /// No description provided for @loginWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Smart finance tracking for a better tomorrow.'**
  String get loginWelcomeMessage;

  /// No description provided for @loginWarningTerms.
  ///
  /// In en, this message translates to:
  /// **'By signing in, you agree to our\nTerms of Service and Privacy Policy.'**
  String get loginWarningTerms;

  /// No description provided for @loginSignInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to your EcoWallet'**
  String get loginSignInToContinue;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @addFilters.
  ///
  /// In en, this message translates to:
  /// **'Add Filters'**
  String get addFilters;

  /// No description provided for @btnApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get btnApply;

  /// No description provided for @btnClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get btnClear;

  /// No description provided for @btnUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get btnUndo;

  /// No description provided for @btnRedo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get btnRedo;

  /// No description provided for @btnSave.
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get btnSave;

  /// No description provided for @btnViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get btnViewAll;

  /// No description provided for @lbOr.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get lbOr;

  /// No description provided for @lbAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get lbAll;

  /// No description provided for @lbName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get lbName;

  /// No description provided for @lbDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get lbDate;

  /// No description provided for @lbHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get lbHome;

  /// No description provided for @lbFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get lbFood;

  /// No description provided for @lbType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get lbType;

  /// No description provided for @lbBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get lbBills;

  /// No description provided for @lbEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get lbEmail;

  /// No description provided for @lbWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get lbWallet;

  /// No description provided for @lbCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get lbCancel;

  /// No description provided for @lbIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get lbIncome;

  /// No description provided for @lbSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get lbSalary;

  /// No description provided for @lbSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get lbSignIn;

  /// No description provided for @lbSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get lbSignUp;

  /// No description provided for @lbPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get lbPassword;

  /// No description provided for @lbHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get lbHealth;

  /// No description provided for @lbOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get lbOthers;

  /// No description provided for @lbAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get lbAmount;

  /// No description provided for @lbReserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get lbReserve;

  /// No description provided for @lbProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get lbProfile;

  /// No description provided for @lbExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get lbExpense;

  /// No description provided for @lbSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get lbSettings;

  /// No description provided for @lbShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get lbShopping;

  /// No description provided for @lbCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get lbCategory;

  /// No description provided for @lbAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get lbAnalytics;

  /// No description provided for @lbTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get lbTransport;

  /// No description provided for @lbUncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get lbUncategorized;

  /// No description provided for @lbEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get lbEntertainment;

  /// No description provided for @lbAllTransactions.
  ///
  /// In en, this message translates to:
  /// **'All Transactions'**
  String get lbAllTransactions;

  /// No description provided for @lbSelectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get lbSelectDateRange;

  /// No description provided for @hintEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get hintEmail;

  /// No description provided for @hintCategory.
  ///
  /// In en, this message translates to:
  /// **'Write the category'**
  String get hintCategory;

  /// No description provided for @hintPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get hintPassword;

  /// No description provided for @hintTransactionName.
  ///
  /// In en, this message translates to:
  /// **'Enter transaction name'**
  String get hintTransactionName;

  /// No description provided for @msgTransactionAdded.
  ///
  /// In en, this message translates to:
  /// **'Transaction added successfully.'**
  String get msgTransactionAdded;

  /// No description provided for @msgTransactionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Transaction updated successfully.'**
  String get msgTransactionUpdated;

  /// No description provided for @msgTransactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted successfully.'**
  String get msgTransactionDeleted;

  /// No description provided for @errorAmountEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount.'**
  String get errorAmountEmpty;

  /// No description provided for @errorCategoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please select a category.'**
  String get errorCategoryEmpty;

  /// No description provided for @errorDateEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please select a date.'**
  String get errorDateEmpty;

  /// No description provided for @errorTitleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title.'**
  String get errorTitleEmpty;

  /// No description provided for @errorAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount.'**
  String get errorAmountInvalid;

  /// No description provided for @errorAmountMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero.'**
  String get errorAmountMustBePositive;

  /// No description provided for @errorAmountFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid number format. Use only digits and a decimal separator.'**
  String get errorAmountFormat;

  /// No description provided for @lbMonthlyProgress.
  ///
  /// In en, this message translates to:
  /// **'Monthly Progress'**
  String get lbMonthlyProgress;

  /// No description provided for @lbEcoFootprint.
  ///
  /// In en, this message translates to:
  /// **'Carbon Footprint'**
  String get lbEcoFootprint;

  /// No description provided for @ecoFootprintValue.
  ///
  /// In en, this message translates to:
  /// **'{value} kg CO₂'**
  String ecoFootprintValue(String value);

  /// No description provided for @lbEcoFootprintCompensation.
  ///
  /// In en, this message translates to:
  /// **'Compensation needed:'**
  String get lbEcoFootprintCompensation;

  /// No description provided for @ecoFootprintCompensation.
  ///
  /// In en, this message translates to:
  /// **'{count} trees 🌳'**
  String ecoFootprintCompensation(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
