import 'package:eco_wallet/core/utils/carbon_calculator.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';

import '../../../wallet/domain/entities/transaction.dart';

class EcoData {
  final double carbonFootprint;
  final int treesPlanted;

  EcoData({
    required this.carbonFootprint,
    required this.treesPlanted,
  });

  factory EcoData.fromTransactions(AppLocalizations loc, List<Transaction> transactions) {
    final totalEmissions = CarbonCalculator.calculateCarbonFootprint(transactions, loc);
    final trees = CarbonCalculator.treesNeeded(totalEmissions);

    return EcoData(
      carbonFootprint: totalEmissions,
      treesPlanted: trees,
    );
  }
}
