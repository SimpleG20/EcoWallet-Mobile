import 'package:eco_wallet/features/settings/data/model/personal_preferences_model.dart';
import 'package:eco_wallet/features/settings/data/model/settings_data_model.dart';
import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/exceptions.dart';
import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/features/settings/domain/entities/user.dart';
import 'package:eco_wallet/features/settings/domain/entities/user_preferences.dart';
import 'package:eco_wallet/features/settings/domain/repositories/base_setting_repository.dart';

import '../datasources/base_settings_data_source.dart';

class SettingsRepositoryImpl implements BaseSettingRepository {
  final BaseSettingsDataSource dataSource;

  SettingsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<BaseFailure, UserPreferences>> getUserPreferences() async {
    try {
      return await dataSource.getUserPreferences();
    } on CacheException {
      return Left(CacheFailure("Failed to fetch settings from cache"));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<BaseFailure, User>> getUser() async {
    try {
      return dataSource.getUser();
    } on CacheException {
      return Left(CacheFailure("Failed to fetch user from cache"));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<BaseFailure, Unit>> updateUser(UserModel user) async {
    try {
      await dataSource.updateUser(user);
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure("Failed to update user in cache"));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<BaseFailure, UserPreferences>> updateUserPreferences(UserPreferencesModel userPreferences) async {
    try {
      await dataSource.updateUserPreferences(userPreferences);
      return Right(userPreferences);
    } on CacheException {
      return Left(CacheFailure("Failed to update settings in cache"));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
