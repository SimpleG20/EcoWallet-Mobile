import 'package:eco_wallet/core/utils/carbon_calculator.dart';

import '../../../wallet/domain/entities/transaction.dart';

class EcoData {
  final double carbonFootprint;
  final int treesPlanted;

  EcoData({
    required this.carbonFootprint,
    required this.treesPlanted,
  });

  factory EcoData.fromTransactions(List<Transaction> transactions) {
    final totalEmissions = CarbonCalculator.calculateCarbonFootprint(transactions);
    final trees = CarbonCalculator.treesNeeded(totalEmissions);

    return EcoData(
      carbonFootprint: totalEmissions,
      treesPlanted: trees,
    );
  }
}

