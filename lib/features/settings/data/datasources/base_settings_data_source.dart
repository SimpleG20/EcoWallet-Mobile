import '../model/settings_data_model.dart';
import '../../domain/entities/user_preferences.dart';

abstract class BaseSettingsDataSource {
  Future<UserPreferences> getUserPreferences(String id);
  Future<void> updateUserPreferences(UserPreferencesModel preferences);
}
