import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/base_failure.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/user_preferences.dart';
import '../repositories/base_setting_repository.dart';
import '../../data/model/settings_data_model.dart';

class UpdateUserPreferences implements BaseUsecase<UserPreferences, UserPreferencesModel> {
  final BaseSettingRepository repository;
  UpdateUserPreferences(this.repository);

  @override
  Future<Either<BaseFailure, UserPreferences>> call(UserPreferencesModel params) async {
    return await repository.updateUserPreferences(params);
  }
}
