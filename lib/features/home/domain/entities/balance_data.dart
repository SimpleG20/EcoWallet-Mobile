import 'package:equatable/equatable.dart';

class BalanceData extends Equatable {
  final double totalBalance;
  final double monthlySavings;
  final String balanceLabel;
  final String savingsLabel;

  const BalanceData({
    required this.totalBalance,
    required this.monthlySavings,
    required this.balanceLabel,
    required this.savingsLabel,
  });

  @override
  List<Object?> get props => [
        totalBalance,
        monthlySavings,
        balanceLabel,
        savingsLabel,
      ];
}
