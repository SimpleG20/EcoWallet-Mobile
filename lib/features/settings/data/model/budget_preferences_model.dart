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

  factory BudgetPreferencesModel.defaults() {
    return const BudgetPreferencesModel(
      monthStartDay: 1,
      monthlyExpenseLimit: null,
      weeklyBudgetLimit: null,
      weeklyAlertPercentage: null,
      dailyBudgetLimit: null,
      dailyAlertPercentage: null,
    );
  }

  factory BudgetPreferencesModel.fromJson(Map<String, dynamic> json) {
    return BudgetPreferencesModel(
      monthStartDay: int.tryParse(json['monthStartDay']) ?? 1,
      monthlyExpenseLimit: double.tryParse(json['monthlyExpenseLimit']),
      weeklyBudgetLimit: double.tryParse(json['weeklyBudgetLimit']),
      weeklyAlertPercentage: int.tryParse(json['weeklyAlertPercentage']),
      dailyBudgetLimit: double.tryParse(json['dailyBudgetLimit']),
      dailyAlertPercentage: int.tryParse(json['dailyAlertPercentage']),
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
