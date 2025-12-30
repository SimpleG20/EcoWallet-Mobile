import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqflite.dart';

import 'package:eco_wallet/core/database/db_helper.dart';

import 'base_settings_data_source.dart';

import '../model/settings_data_model.dart';
import '../model/personal_preferences_model.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/data_preferences.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/entities/budget_preferences.dart';
import '../../domain/entities/appearance_preferences.dart';
import '../../domain/entities/notification_preferences.dart';

import '../../../../core/errors/base_failure.dart';
import '../../../../core/errors/exceptions.dart';

class SettingsLocalDataSource implements BaseSettingsDataSource {
  final DbHelper dbHelper;
  SettingsLocalDataSource({required this.dbHelper});

  @override
  Future<Either<BaseFailure, UserPreferences>> getUserPreferences() async {
    try {
      final db = await dbHelper.database;

      final List<Map<String, dynamic>> maps = await db.query('settings');

      if (maps.isNotEmpty) {
        final settingsMap = maps.first;
        final settings = UserPreferencesModel.fromJson(settingsMap);
        return Right(settings);
      } else {
        final newSettings = UserPreferencesModel(
          appearancePreferences: AppearancePreferences.defaults(),
          notificationPreferences: NotificationPreferences.defaults(),
          budgetPreferences: BudgetPreferences.defaults(),
          dataPreferences: DataPreferences.defaults(),
        );

        await updateUserPreferences(newSettings);

        return Right(newSettings);
      }
    } catch (e) {
      rethrow;
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

  @override
  Future<Either<BaseFailure, User>> getUser() async {
    try {
      final db = await dbHelper.database;

      final List<Map<String, dynamic>> maps = await db.query('users');

      if (maps.isNotEmpty) {
        final userMap = maps.first;
        final user = UserModel.fromJson(userMap);
        return Future.value(Right(user));
      } else {
        return Future.value(Left(CacheFailure('No user found')));
      }
    } catch (e) {
      return Future.value(Left(UnknownFailure(e.toString())));
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      final db = await dbHelper.database;

      await db.insert(
        'users',
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Failed to update user in db');
    }
  }
}
