import 'package:eco_wallet/l10n/app_localizations.dart';

import 'package:eco_wallet/core/enums/enums.dart';

class TransactionTypeRepository {
  /// Gets the localized label for a transaction type.
  static String getLabel(ETransactionType type, AppLocalizations loc) {
    switch (type) {
      case ETransactionType.income:
        return loc.lbIncome;
      case ETransactionType.expense:
        return loc.lbExpense;
    }
  }

  static ETransactionType? fromLabel(String label, AppLocalizations loc) {
    if (label == loc.lbIncome) return ETransactionType.income;
    if (label == loc.lbExpense) return ETransactionType.expense;
    return null;
  }
}
