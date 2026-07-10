import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/settings/domain/entities/user_preferences.dart';
import 'package:eco_wallet/features/settings/domain/repositories/base_setting_repository.dart';
import 'package:eco_wallet/features/settings/data/model/settings_data_model.dart';

class UpdateUserPreferences implements BaseUsecase<UserPreferences, UserPreferencesModel> {
  final BaseSettingRepository repository;
  UpdateUserPreferences(this.repository);

  @override
  Future<Either<BaseFailure, UserPreferences>> call(UserPreferencesModel params) async {
    return await repository.updateUserPreferences(params);
  }
}
