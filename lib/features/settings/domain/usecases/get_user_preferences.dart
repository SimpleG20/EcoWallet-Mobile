import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/settings/domain/entities/user_preferences.dart';
import 'package:eco_wallet/features/settings/domain/repositories/base_setting_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUserPreferences implements BaseUsecase<UserPreferences, String> {
  final BaseSettingRepository repository;
  GetUserPreferences(this.repository);

  @override
  Future<Either<BaseFailure, UserPreferences>> call(String id) async {
    return await repository.getUserPreferences(id);
  }
}
