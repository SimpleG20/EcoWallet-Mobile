import 'package:sqflite/sqflite.dart';

import 'package:eco_wallet/features/settings/data/datasources/base_settings_data_source.dart';

import 'package:eco_wallet/features/settings/data/model/settings_data_model.dart';
import 'package:eco_wallet/features/settings/domain/entities/user_preferences.dart';

import 'package:eco_wallet/core/errors/exceptions.dart';
import 'package:eco_wallet/core/database/db_helper.dart';

class SettingsLocalDataSource implements BaseSettingsDataSource {
  final DbHelper dbHelper;
  SettingsLocalDataSource({required this.dbHelper});

  @override
  Future<UserPreferences> getUserPreferences(String id) async {
    try {
      final db = await dbHelper.database;

      final List<Map<String, dynamic>> maps = await db.query(
        'settings',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return UserPreferencesModel.fromJson(maps.first);
      } else {
        final defaultPreferences = UserPreferencesModel.defaults(id: id);
        await updateUserPreferences(defaultPreferences);
        return defaultPreferences;
      }
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw CacheException('Failed to fetch user preferences from db');
    }
  }

  @override
  Future<void> updateUserPreferences(UserPreferencesModel settings) async {
    try {
      final db = await dbHelper.database;

      await db.insert(
        'settings',
        settings.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Failed to update user preferences in db');
    }
  }
}
