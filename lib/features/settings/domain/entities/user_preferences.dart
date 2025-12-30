import 'package:eco_wallet/features/settings/domain/entities/settings_entities.dart';

class UserPreferences {
  DataPreferences dataPreferences;
  AppearancePreferences appearancePreferences;
  BudgetPreferences budgetPreferences;
  NotificationPreferences notificationPreferences;

  UserPreferences({
    required this.dataPreferences,
    required this.appearancePreferences,
    required this.budgetPreferences,
    required this.notificationPreferences,
  });
}
