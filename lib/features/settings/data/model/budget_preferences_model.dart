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
      monthStartDay: _parseInt(json['monthStartDay'], 1),
      monthlyExpenseLimit: _parseDouble(json['monthlyExpenseLimit']),
      weeklyBudgetLimit: _parseDouble(json['weeklyBudgetLimit']),
      weeklyAlertPercentage: _parseNullableInt(json['weeklyAlertPercentage']),
      dailyBudgetLimit: _parseDouble(json['dailyBudgetLimit']),
      dailyAlertPercentage: _parseNullableInt(json['dailyAlertPercentage']),
    );
  }

  /// Parses an int value from JSON that may be an int or string.
  static int _parseInt(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// Parses a nullable int value from JSON that may be an int or string.
  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Parses a nullable double value from JSON that may be a num or string.
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
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
