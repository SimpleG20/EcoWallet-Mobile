import 'package:eco_wallet/core/constants/category_data.dart';
import 'package:eco_wallet/core/constants/transaction_type_data.dart';

import '../../features/wallet/domain/entities/transaction.dart';
import '../../l10n/app_localizations.dart';

class CarbonCalculator {
  static double calculateCarbonFootprint(List<Transaction> transactions, AppLocalizations loc) {
    double totalCo2 = 0.0;

    for (var t in transactions) {
      if (t.type == ETransactionType.income || t.type == ETransactionType.reserve) continue;

      double factor = 0.1;

      final cat = t.category;
      switch (CategoryRepository.fromLabel(cat, loc)) {
        case ETransactionCategory.food:
        case ETransactionCategory.shopping:
          factor = 0.25;
          break;
        case ETransactionCategory.transport:
          factor = 0.45;
          break;
        case ETransactionCategory.entertainment:
        case ETransactionCategory.bills:
          factor = 0.05;
          break;
        default:
          factor = 0.1;
      }
      totalCo2 += t.amount * factor;
    }
    return totalCo2;
  }

  static int treesNeeded(double co2) {
    return (co2 / 22).ceil();
  }
}
