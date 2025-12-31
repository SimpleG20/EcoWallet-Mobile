import 'package:eco_wallet/features/settings/data/model/user_model.dart';
import 'package:eco_wallet/features/settings/data/model/settings_data_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/user_preferences.dart';
import '../../../../core/errors/base_failure.dart';

abstract class BaseSettingsDataSource {
  Future<Either<BaseFailure, User>> getUser();
  Future<Either<BaseFailure, UserPreferences>> getUserPreferences();
  Future<void> updateUser(UserModel user);
  Future<void> updateUserPreferences(UserPreferencesModel preferences);
}
