import '../../features/wallet/domain/entities/transaction.dart';
import '../enums/enums.dart';

class CarbonCalculator {
  static double calculateCarbonFootprint(List<Transaction> transactions) {
    double totalCo2 = 0.0;

    for (var t in transactions) {
      if (t.type == ETransactionType.income) continue;

      double factor = 0.1;

      switch (t.category) {
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

