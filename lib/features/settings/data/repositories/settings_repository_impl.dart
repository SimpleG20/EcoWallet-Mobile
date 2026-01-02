import 'package:fpdart/fpdart.dart';

import '../model/settings_data_model.dart';
import '../datasources/base_settings_data_source.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/repositories/base_setting_repository.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/base_failure.dart';

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
