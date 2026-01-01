import 'package:eco_wallet/features/settings/domain/entities/settings_entities.dart';

class UserPreferences {
  String id;
  DataPreferences dataPreferences;
  AppearancePreferences appearancePreferences;
  BudgetPreferences budgetPreferences;
  NotificationPreferences notificationPreferences;

  UserPreferences({
    required this.id,
    required this.dataPreferences,
    required this.appearancePreferences,
    required this.budgetPreferences,
    required this.notificationPreferences,
  });

  UserPreferences copyWith({
    DataPreferences? dataPreferences,
    AppearancePreferences? appearancePreferences,
    BudgetPreferences? budgetPreferences,
    NotificationPreferences? notificationPreferences,
  }) {
    return UserPreferences(
      id: id,
      dataPreferences: dataPreferences ?? this.dataPreferences,
      appearancePreferences: appearancePreferences ?? this.appearancePreferences,
      budgetPreferences: budgetPreferences ?? this.budgetPreferences,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
    );
  }
}
