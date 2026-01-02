import 'package:equatable/equatable.dart';

/// Entity representing budget configuration.
class BudgetPreferences extends Equatable {
  final int monthStartDay;
  final double? dailyBudgetLimit;
  final double? monthlyExpenseLimit;
  final double? weeklyBudgetLimit;
  final int? dailyAlertPercentage;
  final int? weeklyAlertPercentage;

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
    int? weeklyAlertPercentage,
    double? dailyBudgetLimit,
    int? dailyAlertPercentage,
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
