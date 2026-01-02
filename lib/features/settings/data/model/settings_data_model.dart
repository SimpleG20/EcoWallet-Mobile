import '../../domain/entities/user_preferences.dart';

import 'data_preferences_model.dart';
import 'budget_preferences_model.dart';
import 'appearance_preferences_model.dart';
import 'notification_preferences_model.dart';

class UserPreferencesModel extends UserPreferences {
  UserPreferencesModel({
    required super.id,
    required super.appearancePreferences,
    required super.notificationPreferences,
    required super.budgetPreferences,
    required super.dataPreferences,
  });

  factory UserPreferencesModel.defaults({required String id}) {
    return UserPreferencesModel(
      id: id,
      appearancePreferences: AppearancePreferencesModel.defaults(),
      notificationPreferences: NotificationPreferencesModel.defaults(),
      budgetPreferences: BudgetPreferencesModel.defaults(),
      dataPreferences: DataPreferencesModel.defaults(),
    );
  }

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final appearance = makeMap(json['appearancePreferences']);
    final notifications = makeMap(json['notificationPreferences']);
    final budget = makeMap(json['budgetPreferences']);
    final data = makeMap(json['dataPreferences']);

    return UserPreferencesModel(
      id: id,
      appearancePreferences: AppearancePreferencesModel.fromJson(appearance),
      notificationPreferences: NotificationPreferencesModel.fromJson(notifications),
      budgetPreferences: BudgetPreferencesModel.fromJson(budget),
      dataPreferences: DataPreferencesModel.fromJson(data),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appearancePreferences': AppearancePreferencesModel.toJson(appearancePreferences),
      'notificationPreferences': NotificationPreferencesModel.toJson(notificationPreferences),
      'budgetPreferences': BudgetPreferencesModel.toJson(budgetPreferences),
      'dataPreferences': DataPreferencesModel.toJson(dataPreferences),
    };
  }

  /// Converts a domain [UserPreferences] entity to a [UserPreferencesModel] for persistence.
  factory UserPreferencesModel.fromEntity(UserPreferences entity) {
    return UserPreferencesModel(
      id: entity.id,
      appearancePreferences: entity.appearancePreferences,
      notificationPreferences: entity.notificationPreferences,
      budgetPreferences: entity.budgetPreferences,
      dataPreferences: entity.dataPreferences,
    );
  }
}

Map<String, dynamic> makeMap(String value) {
  value = value.replaceAll('{', '');
  value = value.replaceAll('}', '');
  var split = value.split(';');
  Map<String, dynamic> map = {};
  for (var item in split) {
    item = item.trim();
    var keyValue = item.split('=');
    if (keyValue.length == 2) {
      map[keyValue[0].trim()] = keyValue[1].trim();
    }
  }
  return map;
}
