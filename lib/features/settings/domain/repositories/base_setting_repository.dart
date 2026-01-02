import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/base_failure.dart';
import '../entities/user_preferences.dart';
import '../../data/model/settings_data_model.dart';

abstract class BaseSettingRepository {
  Future<Either<BaseFailure, UserPreferences>> getUserPreferences(String id);
  Future<Either<BaseFailure, UserPreferences>> updateUserPreferences(UserPreferencesModel userPreferences);
}
