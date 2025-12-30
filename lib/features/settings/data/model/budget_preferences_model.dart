import 'package:eco_wallet/features/settings/domain/entities/budget_preferences.dart';

class BudgetPreferencesModel extends BudgetPreferences {
  const BudgetPreferencesModel({
    required super.monthStartDay,
    required super.monthlyExpenseLimit,
    required super.weeklyBudgetLimit,
    required super.weeklyAlertPercentage,
    required super.dailyBudgetLimit,
    required super.dailyAlertPercentage,
  });

  factory BudgetPreferencesModel.fromJson(Map<String, dynamic> json) {
    return BudgetPreferencesModel(
      monthStartDay: json['monthStartDay'] as int,
      monthlyExpenseLimit: json['monthlyExpenseLimit'] as double,
      weeklyBudgetLimit: json['weeklyBudgetLimit'] as double,
      weeklyAlertPercentage: json['weeklyAlertPercentage'] as double,
      dailyBudgetLimit: json['dailyBudgetLimit'] as double,
      dailyAlertPercentage: json['dailyAlertPercentage'] as double,
    );
  }

  static Map<String, dynamic> toJson(BudgetPreferences preferences) {
    return {
      'monthStartDay': preferences.monthStartDay,
      'monthlyExpenseLimit': preferences.monthlyExpenseLimit,
      'weeklyBudgetLimit': preferences.weeklyBudgetLimit,
      'weeklyAlertPercentage': preferences.weeklyAlertPercentage,
      'dailyBudgetLimit': preferences.dailyBudgetLimit,
      'dailyAlertPercentage': preferences.dailyAlertPercentage,
    };
  }
}
