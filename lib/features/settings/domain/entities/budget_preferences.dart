import 'package:equatable/equatable.dart';

/// Entity representing budget configuration.
class BudgetPreferences extends Equatable {
  final int monthStartDay;
  final double? monthlyExpenseLimit;
  final double? weeklyBudgetLimit;
  final double? weeklyAlertPercentage;
  final double? dailyBudgetLimit;
  final double? dailyAlertPercentage;

  const BudgetPreferences({
    this.monthStartDay = 1,
    this.monthlyExpenseLimit,
    this.weeklyBudgetLimit,
    this.weeklyAlertPercentage,
    this.dailyBudgetLimit,
    this.dailyAlertPercentage,
  });

  BudgetPreferences copyWith({
    int? monthStartDay,
    double? monthlyExpenseLimit,
    double? weeklyBudgetLimit,
    double? weeklyAlertPercentage,
    double? dailyBudgetLimit,
    double? dailyAlertPercentage,
  }) {
    return BudgetPreferences(
      monthStartDay: monthStartDay ?? this.monthStartDay,
      monthlyExpenseLimit: monthlyExpenseLimit ?? this.monthlyExpenseLimit,
      weeklyBudgetLimit: weeklyBudgetLimit ?? this.weeklyBudgetLimit,
      weeklyAlertPercentage: weeklyAlertPercentage ?? this.weeklyAlertPercentage,
      dailyBudgetLimit: dailyBudgetLimit ?? this.dailyBudgetLimit,
      dailyAlertPercentage: dailyAlertPercentage ?? this.dailyAlertPercentage,
    );
  }

  @override
  List<Object?> get props => [
        monthStartDay,
        monthlyExpenseLimit,
        weeklyBudgetLimit,
        weeklyAlertPercentage,
        dailyBudgetLimit,
        dailyAlertPercentage,
      ];
}
