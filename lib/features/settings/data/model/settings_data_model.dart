import '../../domain/entities/user_preferences.dart';

import 'data_preferences_model.dart';
import 'budget_preferences_model.dart';
import 'appearance_preferences_model.dart';
import 'notification_preferences_model.dart';

class UserPreferencesModel extends UserPreferences {
  UserPreferencesModel({
    required super.appearancePreferences,
    required super.notificationPreferences,
    required super.budgetPreferences,
    required super.dataPreferences,
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      appearancePreferences: AppearancePreferencesModel.fromJson(json['appearancePreferences']),
      notificationPreferences: NotificationPreferencesModel.fromJson(json['notificationPreferences']),
      budgetPreferences: BudgetPreferencesModel.fromJson(json['budgetPreferences']),
      dataPreferences: DataPreferencesModel.fromJson(json['dataPreferences']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appearancePreferences': AppearancePreferencesModel.toJson(appearancePreferences),
      'notificationPreferences': NotificationPreferencesModel.toJson(notificationPreferences),
      'budgetPreferences': BudgetPreferencesModel.toJson(budgetPreferences),
      'dataPreferences': DataPreferencesModel.toJson(dataPreferences),
    };
  }
}
