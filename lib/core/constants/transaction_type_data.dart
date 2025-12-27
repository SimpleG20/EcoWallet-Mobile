import 'package:eco_wallet/l10n/app_localizations.dart';

enum ETransactionType { income, expense, reserve }

class TransactionTypeRepository {
  /// Gets the localized label for a transaction type.
  static String getLabel(ETransactionType type, AppLocalizations loc) {
    switch (type) {
      case ETransactionType.income:
        return loc.lbIncome;
      case ETransactionType.expense:
        return loc.lbExpense;
      case ETransactionType.reserve:
        return loc.lbReserve;
    }
  }

  static ETransactionType? fromLabel(String label, AppLocalizations loc) {
    if (label == loc.lbIncome) return ETransactionType.income;
    if (label == loc.lbExpense) return ETransactionType.expense;
    if (label == loc.lbReserve) return ETransactionType.reserve;
    return null;
  }
}
