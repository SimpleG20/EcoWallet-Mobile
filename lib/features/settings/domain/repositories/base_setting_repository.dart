import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/base_failure.dart';
import '../entities/user.dart';
import '../entities/user_preferences.dart';
import '../../data/model/personal_preferences_model.dart';
import '../../data/model/settings_data_model.dart';

abstract class BaseSettingRepository {
  Future<Either<BaseFailure, User>> getUser();
  Future<Either<BaseFailure, UserPreferences>> getUserPreferences();

  Future<Either<BaseFailure, Unit>> updateUser(UserModel user);
  Future<Either<BaseFailure, UserPreferences>> updateUserPreferences(UserPreferencesModel userPreferences);
}
