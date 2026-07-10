import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/features/settings/data/model/settings_data_model.dart';
import 'package:eco_wallet/features/settings/data/datasources/base_settings_data_source.dart';
import 'package:eco_wallet/features/settings/domain/entities/user_preferences.dart';
import 'package:eco_wallet/features/settings/domain/repositories/base_setting_repository.dart';
import 'package:eco_wallet/core/errors/exceptions.dart';
import 'package:eco_wallet/core/errors/base_failure.dart';

class SettingsRepositoryImpl implements BaseSettingRepository {
  final BaseSettingsDataSource dataSource;

  SettingsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<BaseFailure, UserPreferences>> getUserPreferences(String id) async {
    try {
      final result = await dataSource.getUserPreferences(id);
      return Right(result);
    } on CacheException {
      return Left(CacheFailure("Failed to fetch settings from cache"));
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
