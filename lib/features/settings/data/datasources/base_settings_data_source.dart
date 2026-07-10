import 'package:eco_wallet/features/settings/data/model/settings_data_model.dart';
import 'package:eco_wallet/features/settings/domain/entities/user_preferences.dart';

abstract class BaseSettingsDataSource {
  Future<UserPreferences> getUserPreferences(String id);
  Future<void> updateUserPreferences(UserPreferencesModel preferences);
}
