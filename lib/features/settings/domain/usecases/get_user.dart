import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/settings/domain/entities/user.dart';
import 'package:eco_wallet/features/settings/domain/repositories/base_setting_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUser implements BaseUsecase<User, NoParams> {
  final BaseSettingRepository repository;
  GetUser(this.repository);

  @override
  Future<Either<BaseFailure, User>> call(NoParams params) async {
    return await repository.getUser();
  }
}
