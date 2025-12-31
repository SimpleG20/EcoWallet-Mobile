import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/user/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/base_user_repository.dart';

class UpdateUser implements BaseUsecase<Unit, User> {
  final BaseUserRepository repository;

  UpdateUser(this.repository);

  @override
  Future<Either<BaseFailure, Unit>> call(User params) {
    return repository.updateUser(params);
  }
}
