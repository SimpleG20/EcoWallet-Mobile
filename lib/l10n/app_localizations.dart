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

  /// No description provided for @filterTransactions.
  ///
  /// In en, this message translates to:
  /// **'Filter Transactions'**
  String get filterTransactions;

  /// No description provided for @searchTransactions.
  ///
  /// In en, this message translates to:
  /// **'Search transactions...'**
  String get searchTransactions;

  /// No description provided for @addFilters.
  ///
  /// In en, this message translates to:
  /// **'Add Filters'**
  String get addFilters;

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

  /// No description provided for @helpSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Get help and support'**
  String get helpSubTitle;

  /// No description provided for @feedbackSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Send us your feedback'**
  String get feedbackSubTitle;

  /// No description provided for @termsSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get termsSubTitle;

  /// No description provided for @settingsSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your app settings'**
  String get settingsSubTitle;

  /// No description provided for @privacySubTitle.
  ///
  /// In en, this message translates to:
  /// **'Review our privacy policies'**
  String get privacySubTitle;

  /// No description provided for @policySubTitle.
  ///
  /// In en, this message translates to:
  /// **'Understand our privacy policy'**
  String get policySubTitle;

  /// No description provided for @passwordSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Change your account password'**
  String get passwordSubTitle;

  /// No description provided for @securitySubTitle.
  ///
  /// In en, this message translates to:
  /// **'Enhance your account security'**
  String get securitySubTitle;

  /// No description provided for @budgetInfoSubTitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage your budget'**
  String get budgetInfoSubTitle;

  /// No description provided for @manageDataSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your data preferences'**
  String get manageDataSubTitle;

  /// No description provided for @personalInfoSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get personalInfoSubTitle;

  /// No description provided for @notificationsSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your notification preferences'**
  String get notificationsSubTitle;

  /// No description provided for @appearanceSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Customize the look and feel of the app'**
  String get appearanceSubTitle;

  /// No description provided for @unsavedChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChangesTitle;

  /// No description provided for @askForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get askForgotPassword;

  /// No description provided for @askAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get askAlreadyHaveAccount;

  /// No description provided for @askDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get askDontHaveAccount;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @loginSignInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to your EcoWallet'**
  String get loginSignInToContinue;

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

  /// No description provided for @loginErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginErrorGeneric;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password Requirements'**
  String get passwordRequirements;

  /// No description provided for @pwRequirementNumber.
  ///
  /// In en, this message translates to:
  /// **'At least one number'**
  String get pwRequirementNumber;

  /// No description provided for @pwRequirementLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum of 8 characters'**
  String get pwRequirementLength;

  /// No description provided for @pwRequirementUppercase.
  ///
  /// In en, this message translates to:
  /// **'At least one uppercase letter'**
  String get pwRequirementUppercase;

  /// No description provided for @pwRequirementSpecial.
  ///
  /// In en, this message translates to:
  /// **'At least one special character'**
  String get pwRequirementSpecial;

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

  /// No description provided for @btnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btnCancel;

  /// No description provided for @btnViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get btnViewAll;

  /// No description provided for @btnSave.
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get btnSave;

  /// No description provided for @btnDiscardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard Changes'**
  String get btnDiscardChanges;

  /// No description provided for @btnSendTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Test Notification'**
  String get btnSendTestNotification;

  /// No description provided for @lbOr.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get lbOr;

  /// No description provided for @lbTo.
  ///
  /// In en, this message translates to:
  /// **'To:'**
  String get lbTo;

  /// No description provided for @lbFrom.
  ///
  /// In en, this message translates to:
  /// **'From:'**
  String get lbFrom;

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

  /// No description provided for @lbPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get lbPhone;

  /// No description provided for @lbTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get lbTheme;

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

  /// No description provided for @lbDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get lbDelete;

  /// No description provided for @lbImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get lbImport;

  /// No description provided for @lbExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get lbExport;

  /// No description provided for @lbLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get lbLogout;

  /// No description provided for @lbSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get lbSupport;

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

  /// No description provided for @lbAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get lbAccount;

  /// No description provided for @lbAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get lbAddress;

  /// No description provided for @lbDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get lbDismiss;

  /// No description provided for @lbSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get lbSettings;

  /// No description provided for @lbSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get lbSecurity;

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

  /// No description provided for @lbPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get lbPassword;

  /// No description provided for @lbFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get lbFontSize;

  /// No description provided for @lbFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get lbFullName;

  /// No description provided for @lbEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Encrypted'**
  String get lbEncrypted;

  /// No description provided for @lbFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get lbFrequency;

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

  /// No description provided for @lbAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get lbAppearance;

  /// No description provided for @lbAnimations.
  ///
  /// In en, this message translates to:
  /// **'Animations'**
  String get lbAnimations;

  /// No description provided for @lbHideValues.
  ///
  /// In en, this message translates to:
  /// **'Hide Values'**
  String get lbHideValues;

  /// No description provided for @lbLimitAlert.
  ///
  /// In en, this message translates to:
  /// **'Limit Alert'**
  String get lbLimitAlert;

  /// No description provided for @lbQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours'**
  String get lbQuietHours;

  /// No description provided for @lbBudgetInfo.
  ///
  /// In en, this message translates to:
  /// **'Budget Info'**
  String get lbBudgetInfo;

  /// No description provided for @lbManageData.
  ///
  /// In en, this message translates to:
  /// **'Manage Data'**
  String get lbManageData;

  /// No description provided for @lbExportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get lbExportData;

  /// No description provided for @lbDeleteData.
  ///
  /// In en, this message translates to:
  /// **'Delete Data'**
  String get lbDeleteData;

  /// No description provided for @lbHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get lbHelpCenter;

  /// No description provided for @lbDateBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get lbDateBirth;

  /// No description provided for @lbPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get lbPreferences;

  /// No description provided for @lbEnableCloud.
  ///
  /// In en, this message translates to:
  /// **'Enable Cloud'**
  String get lbEnableCloud;

  /// No description provided for @lbAboutLegal.
  ///
  /// In en, this message translates to:
  /// **'About & Legal'**
  String get lbAboutLegal;

  /// No description provided for @lbNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get lbNewPassword;

  /// No description provided for @lbBudgetLimit.
  ///
  /// In en, this message translates to:
  /// **'Budget Limit'**
  String get lbBudgetLimit;

  /// No description provided for @lbPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get lbPersonalInfo;

  /// No description provided for @lbSendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get lbSendFeedback;

  /// No description provided for @lbBackupData.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get lbBackupData;

  /// No description provided for @lbNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get lbNotifications;

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

  /// No description provided for @lbEditThreshold.
  ///
  /// In en, this message translates to:
  /// **'Edit Threshold'**
  String get lbEditThreshold;

  /// No description provided for @lbPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get lbPrivacyPolicy;

  /// No description provided for @lbBillsReminder.
  ///
  /// In en, this message translates to:
  /// **'Bills Reminder'**
  String get lbBillsReminder;

  /// No description provided for @lbDailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get lbDailyReminder;

  /// No description provided for @lbExpensesLimit.
  ///
  /// In en, this message translates to:
  /// **'Expenses Limit'**
  String get lbExpensesLimit;

  /// No description provided for @lbMonthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report'**
  String get lbMonthlyReport;

  /// No description provided for @lbCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get lbCreateAccount;

  /// No description provided for @lbEcoFootprint.
  ///
  /// In en, this message translates to:
  /// **'Carbon Footprint'**
  String get lbEcoFootprint;

  /// No description provided for @lbChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get lbChangePassword;

  /// No description provided for @lbCurrencyFormat.
  ///
  /// In en, this message translates to:
  /// **'Currency Format'**
  String get lbCurrencyFormat;

  /// No description provided for @lbColorBlindMode.
  ///
  /// In en, this message translates to:
  /// **'Color Blind Mode'**
  String get lbColorBlindMode;

  /// No description provided for @lbTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get lbTermsOfService;

  /// No description provided for @lbMonthlyProgress.
  ///
  /// In en, this message translates to:
  /// **'Monthly Progress'**
  String get lbMonthlyProgress;

  /// No description provided for @lbAllTransactions.
  ///
  /// In en, this message translates to:
  /// **'All Transactions'**
  String get lbAllTransactions;

  /// No description provided for @lbCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get lbCurrentPassword;

  /// No description provided for @lbConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get lbConfirmPassword;

  /// No description provided for @lbSelectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get lbSelectDateRange;

  /// No description provided for @lbBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get lbBiometrics;

  /// No description provided for @lbEnergySavingTips.
  ///
  /// In en, this message translates to:
  /// **'Energy Saving Tips'**
  String get lbEnergySavingTips;

  /// No description provided for @lbConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get lbConfirmNewPassword;

  /// No description provided for @lbInitialDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Initial Day of the Month'**
  String get lbInitialDayOfMonth;

  /// No description provided for @lbHighConsumptionAlert.
  ///
  /// In en, this message translates to:
  /// **'High Consumption Alert'**
  String get lbHighConsumptionAlert;

  /// No description provided for @lbCreateAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started!'**
  String get lbCreateAccountSubtitle;

  /// No description provided for @lbAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Service and Privacy Policy.'**
  String get lbAgreeTerms;

  /// No description provided for @msgTestNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent!'**
  String get msgTestNotificationSent;

  /// No description provided for @msgFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature is coming soon!'**
  String get msgFeatureComingSoon;

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

  /// No description provided for @msgUnsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes.\nAre you sure you want to discard them?'**
  String get msgUnsavedChanges;

  /// No description provided for @hintDateBirth.
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY'**
  String get hintDateBirth;

  /// No description provided for @hintEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get hintEmail;

  /// No description provided for @hintAddress.
  ///
  /// In en, this message translates to:
  /// **'<City>, <State>, <Country>'**
  String get hintAddress;

  /// No description provided for @hintAddressFormat.
  ///
  /// In en, this message translates to:
  /// **'<City>, <State>, <Country>'**
  String get hintAddressFormat;

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

  /// No description provided for @hintFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get hintFullName;

  /// No description provided for @hintPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'+1 (XXX) XXX-XXXX'**
  String get hintPhoneNumber;

  /// No description provided for @hintConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get hintConfirmPassword;

  /// No description provided for @hintTransactionName.
  ///
  /// In en, this message translates to:
  /// **'Enter transaction name'**
  String get hintTransactionName;

  /// No description provided for @hintConsumptionThreshold.
  ///
  /// In en, this message translates to:
  /// **'Enter consumption threshold'**
  String get hintConsumptionThreshold;

  /// No description provided for @sectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get sectionGeneral;

  /// No description provided for @sectionDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get sectionDisplay;

  /// No description provided for @sectionAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get sectionAccessibility;

  /// No description provided for @sectionMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get sectionMonthly;

  /// No description provided for @sectionWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get sectionWeekly;

  /// No description provided for @sectionDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get sectionDaily;

  /// No description provided for @sectionDataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get sectionDataManagement;

  /// No description provided for @sectionBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get sectionBackup;

  /// No description provided for @sectionReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get sectionReminders;

  /// No description provided for @sectionReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get sectionReports;

  /// No description provided for @sectionDoNotDisturb.
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb'**
  String get sectionDoNotDisturb;

  /// No description provided for @sectionEcoNotifications.
  ///
  /// In en, this message translates to:
  /// **'Eco Notifications'**
  String get sectionEcoNotifications;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'Symbol (R\$)'**
  String get currencySymbol;

  /// No description provided for @currencyCode.
  ///
  /// In en, this message translates to:
  /// **'Code (BRL)'**
  String get currencyCode;

  /// No description provided for @colorBlindNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get colorBlindNone;

  /// No description provided for @colorBlindProtanopia.
  ///
  /// In en, this message translates to:
  /// **'Protanopia'**
  String get colorBlindProtanopia;

  /// No description provided for @colorBlindDeuteranopia.
  ///
  /// In en, this message translates to:
  /// **'Deuteranopia'**
  String get colorBlindDeuteranopia;

  /// No description provided for @colorBlindTritanopia.
  ///
  /// In en, this message translates to:
  /// **'Tritanopia'**
  String get colorBlindTritanopia;

  /// No description provided for @fontSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get fontSizeSmall;

  /// No description provided for @fontSizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get fontSizeMedium;

  /// No description provided for @fontSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get fontSizeLarge;

  /// No description provided for @expensesLimitDescription.
  ///
  /// In en, this message translates to:
  /// **'Set a limit to control your monthly expenses.'**
  String get expensesLimitDescription;

  /// No description provided for @setMonthlyExpensesLimit.
  ///
  /// In en, this message translates to:
  /// **'Set Monthly Expenses Limit'**
  String get setMonthlyExpensesLimit;

  /// No description provided for @limitAlertDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive an alert when you reach your budget limit.'**
  String get limitAlertDescription;

  /// No description provided for @exportDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Export your data to a file for backup purposes.'**
  String get exportDataDescription;

  /// No description provided for @importDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Import data from a previously exported file.'**
  String get importDataDescription;

  /// No description provided for @deleteDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete all your data from the app.'**
  String get deleteDataDescription;

  /// No description provided for @frequencyNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get frequencyNone;

  /// No description provided for @frequencyDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get frequencyDaily;

  /// No description provided for @frequencyWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get frequencyWeekly;

  /// No description provided for @frequencyMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get frequencyMonthly;

  /// No description provided for @dailyReminderDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive daily notifications about your energy usage'**
  String get dailyReminderDescription;

  /// No description provided for @billsReminderDescription.
  ///
  /// In en, this message translates to:
  /// **'Get notified about upcoming bills'**
  String get billsReminderDescription;

  /// No description provided for @monthlyReportDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive monthly consumption summary'**
  String get monthlyReportDescription;

  /// No description provided for @energySavingTipsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive tips to reduce energy consumption'**
  String get energySavingTipsDescription;

  /// No description provided for @highConsumptionAlertDescription.
  ///
  /// In en, this message translates to:
  /// **'Alert when consumption exceeds threshold'**
  String get highConsumptionAlertDescription;

  /// No description provided for @thresholdLabel.
  ///
  /// In en, this message translates to:
  /// **'Threshold: {value} kWh'**
  String thresholdLabel(String value);

  /// No description provided for @ntfAlertConsumptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Consumption Alert! ⚠️'**
  String get ntfAlertConsumptionTitle;

  /// No description provided for @ntfAlertConsumptionBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve exceeded your limit of {value}'**
  String ntfAlertConsumptionBody(String value);

  /// No description provided for @ntfTestTitle.
  ///
  /// In en, this message translates to:
  /// **'EcoWallet Test Notification'**
  String get ntfTestTitle;

  /// No description provided for @ntfTestBody.
  ///
  /// In en, this message translates to:
  /// **'This is a test notification from EcoWallet. 🌿'**
  String get ntfTestBody;

  /// No description provided for @ntfDailyReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'EcoWallet Reminder'**
  String get ntfDailyReminderTitle;

  /// No description provided for @ntfDailyReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to log your expenses today! 🌱'**
  String get ntfDailyReminderBody;

  /// No description provided for @ntfDailyReminderChannelName.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminders'**
  String get ntfDailyReminderChannelName;

  /// No description provided for @ntfDailyReminderChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Notifies to log expenses daily'**
  String get ntfDailyReminderChannelDescription;

  /// No description provided for @errorNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Name is too short.'**
  String get errorNameInvalid;

  /// No description provided for @errorDateInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid date format.'**
  String get errorDateInvalid;

  /// No description provided for @errorEmpty.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty.'**
  String get errorEmpty;

  /// No description provided for @errorDateOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'Date out of range.'**
  String get errorDateOutOfRange;

  /// No description provided for @errorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format.'**
  String get errorEmailInvalid;

  /// No description provided for @errorPasswordWeak.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak.'**
  String get errorPasswordWeak;

  /// No description provided for @errorAddressInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid address format.'**
  String get errorAddressInvalid;

  /// No description provided for @errorNumberPositive.
  ///
  /// In en, this message translates to:
  /// **'Number must be positive.'**
  String get errorNumberPositive;

  /// No description provided for @errorPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password is too short.'**
  String get errorPasswordTooShort;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get errorPasswordMismatch;

  /// No description provided for @errorPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number format.'**
  String get errorPhoneInvalid;

  /// No description provided for @errorAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount.'**
  String get errorAmountInvalid;

  /// No description provided for @errorAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the terms to continue.'**
  String get errorAgreeTerms;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.\nPlease try again.'**
  String get errorUnknown;

  /// No description provided for @errorAmountMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero.'**
  String get errorAmountMustBePositive;

  /// No description provided for @errorEnterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password.'**
  String get errorEnterCurrentPassword;

  /// No description provided for @errorPercentageInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid percentage (0-100).'**
  String get errorPercentageInvalid;

  /// No description provided for @errorSameAsCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'New password cannot be the same as the current password.'**
  String get errorSameAsCurrentPassword;

  /// No description provided for @errorAmountFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid number format. Use only digits and a decimal separator.'**
  String get errorAmountFormat;

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

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'d love to hear from you!'**
  String get feedbackTitle;

  /// No description provided for @feedbackDescription.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve EcoWallet and create a better experience for everyone.'**
  String get feedbackDescription;

  /// No description provided for @feedbackCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get feedbackCategoryLabel;

  /// No description provided for @feedbackCategoryBug.
  ///
  /// In en, this message translates to:
  /// **'Bug Report'**
  String get feedbackCategoryBug;

  /// No description provided for @feedbackCategorySuggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get feedbackCategorySuggestion;

  /// No description provided for @feedbackCategoryCompliment.
  ///
  /// In en, this message translates to:
  /// **'Compliment'**
  String get feedbackCategoryCompliment;

  /// No description provided for @feedbackCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get feedbackCategoryOther;

  /// No description provided for @feedbackMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Message'**
  String get feedbackMessageLabel;

  /// No description provided for @feedbackMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us what\'s on your mind...'**
  String get feedbackMessageHint;

  /// No description provided for @feedbackEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Email (optional)'**
  String get feedbackEmailLabel;

  /// No description provided for @feedbackEmailHint.
  ///
  /// In en, this message translates to:
  /// **'For follow-up questions'**
  String get feedbackEmailHint;

  /// No description provided for @feedbackSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get feedbackSubmitButton;

  /// No description provided for @feedbackThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get feedbackThankYou;

  /// No description provided for @feedbackCharacterCount.
  ///
  /// In en, this message translates to:
  /// **'{count}/500 characters'**
  String feedbackCharacterCount(int count);

  /// No description provided for @helpFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get helpFaqTitle;

  /// No description provided for @helpSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for help topics...'**
  String get helpSearchHint;

  /// No description provided for @helpFaqAddTransaction.
  ///
  /// In en, this message translates to:
  /// **'How do I add a transaction?'**
  String get helpFaqAddTransaction;

  /// No description provided for @helpFaqAddTransactionAnswer.
  ///
  /// In en, this message translates to:
  /// **'Tap the \'+\' button on the home screen, select the transaction type (income, expense, or reserve), fill in the details, and tap \'Save\'.'**
  String get helpFaqAddTransactionAnswer;

  /// No description provided for @helpFaqEditDelete.
  ///
  /// In en, this message translates to:
  /// **'How do I edit or delete a transaction?'**
  String get helpFaqEditDelete;

  /// No description provided for @helpFaqEditDeleteAnswer.
  ///
  /// In en, this message translates to:
  /// **'Swipe left on the transaction to reveal edit and delete options, or tap on the transaction to open details and use the action buttons.'**
  String get helpFaqEditDeleteAnswer;

  /// No description provided for @helpFaqCategories.
  ///
  /// In en, this message translates to:
  /// **'How do I manage categories?'**
  String get helpFaqCategories;

  /// No description provided for @helpFaqCategoriesAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings > Manage Data to customize your transaction categories.'**
  String get helpFaqCategoriesAnswer;

  /// No description provided for @helpFaqBackup.
  ///
  /// In en, this message translates to:
  /// **'How do I backup my data?'**
  String get helpFaqBackup;

  /// No description provided for @helpFaqBackupAnswer.
  ///
  /// In en, this message translates to:
  /// **'Enable cloud backup in Settings > Manage Data > Backup section. You can also export your data manually.'**
  String get helpFaqBackupAnswer;

  /// No description provided for @helpFaqLanguage.
  ///
  /// In en, this message translates to:
  /// **'How do I change the language?'**
  String get helpFaqLanguage;

  /// No description provided for @helpFaqLanguageAnswer.
  ///
  /// In en, this message translates to:
  /// **'The app follows your device\'s language settings. Change your device language to switch the app language.'**
  String get helpFaqLanguageAnswer;

  /// No description provided for @helpContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get helpContactTitle;

  /// No description provided for @helpContactDescription.
  ///
  /// In en, this message translates to:
  /// **'Still need help? Our support team is here for you.'**
  String get helpContactDescription;

  /// No description provided for @helpContactEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get helpContactEmail;

  /// No description provided for @helpContactChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get helpContactChat;

  /// No description provided for @helpVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get helpVersion;

  /// No description provided for @policyLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: {date}'**
  String policyLastUpdated(String date);

  /// No description provided for @policyIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get policyIntroTitle;

  /// No description provided for @policyIntroContent.
  ///
  /// In en, this message translates to:
  /// **'EcoWallet is committed to protecting your privacy. This policy explains how we collect, use, and safeguard your personal information.'**
  String get policyIntroContent;

  /// No description provided for @policyDataCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get policyDataCollectionTitle;

  /// No description provided for @policyDataCollectionContent.
  ///
  /// In en, this message translates to:
  /// **'We collect information you provide directly, such as your name, email, and financial transaction data. All data is stored securely on your device and optionally in encrypted cloud storage.'**
  String get policyDataCollectionContent;

  /// No description provided for @policyDataUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Data'**
  String get policyDataUsageTitle;

  /// No description provided for @policyDataUsageContent.
  ///
  /// In en, this message translates to:
  /// **'Your data is used solely to provide app functionality, including transaction tracking, budget management, and generating financial reports. We never sell your data to third parties.'**
  String get policyDataUsageContent;

  /// No description provided for @policySecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get policySecurityTitle;

  /// No description provided for @policySecurityContent.
  ///
  /// In en, this message translates to:
  /// **'We implement industry-standard security measures including encryption, secure data transmission, and regular security audits to protect your information.'**
  String get policySecurityContent;

  /// No description provided for @policyRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get policyRightsTitle;

  /// No description provided for @policyRightsContent.
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, modify, export, or delete your data at any time through the app settings. You can also request a complete data deletion by contacting our support team.'**
  String get policyRightsContent;

  /// No description provided for @policyContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get policyContactTitle;

  /// No description provided for @policyContactContent.
  ///
  /// In en, this message translates to:
  /// **'For questions about this privacy policy, please contact us at privacy@ecowallet.app'**
  String get policyContactContent;

  /// No description provided for @termsLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: {date}'**
  String termsLastUpdated(String date);

  /// No description provided for @termsAcceptanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Acceptance of Terms'**
  String get termsAcceptanceTitle;

  /// No description provided for @termsAcceptanceContent.
  ///
  /// In en, this message translates to:
  /// **'By downloading, installing, or using EcoWallet, you agree to be bound by these Terms of Service. If you do not agree, please do not use the app.'**
  String get termsAcceptanceContent;

  /// No description provided for @termsServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Description'**
  String get termsServiceTitle;

  /// No description provided for @termsServiceContent.
  ///
  /// In en, this message translates to:
  /// **'EcoWallet provides personal finance management tools including transaction tracking, budgeting, and financial analytics. The service is provided \'as is\' for personal, non-commercial use.'**
  String get termsServiceContent;

  /// No description provided for @termsAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'User Accounts'**
  String get termsAccountTitle;

  /// No description provided for @termsAccountContent.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the confidentiality of your account credentials and for all activities under your account. You must provide accurate and complete information when creating an account.'**
  String get termsAccountContent;

  /// No description provided for @termsContentTitle.
  ///
  /// In en, this message translates to:
  /// **'User Content'**
  String get termsContentTitle;

  /// No description provided for @termsContentContent.
  ///
  /// In en, this message translates to:
  /// **'You retain all rights to the financial data you enter into the app. By using our cloud backup features, you grant us permission to store and process this data solely for providing the service.'**
  String get termsContentContent;

  /// No description provided for @termsProhibitedTitle.
  ///
  /// In en, this message translates to:
  /// **'Prohibited Uses'**
  String get termsProhibitedTitle;

  /// No description provided for @termsProhibitedContent.
  ///
  /// In en, this message translates to:
  /// **'You may not use EcoWallet for any illegal purposes, to transmit malicious code, or to attempt to access other users\' data. Violation may result in account termination.'**
  String get termsProhibitedContent;

  /// No description provided for @termsLiabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get termsLiabilityTitle;

  /// No description provided for @termsLiabilityContent.
  ///
  /// In en, this message translates to:
  /// **'EcoWallet is not liable for any financial decisions you make based on the app\'s data or analytics. Always consult a financial professional for important financial matters.'**
  String get termsLiabilityContent;

  /// No description provided for @termsChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Changes to Terms'**
  String get termsChangesTitle;

  /// No description provided for @termsChangesContent.
  ///
  /// In en, this message translates to:
  /// **'We may update these terms periodically. Continued use of the app after changes constitutes acceptance of the new terms.'**
  String get termsChangesContent;
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
