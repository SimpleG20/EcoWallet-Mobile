import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/user/domain/entities/user.dart';
import 'package:eco_wallet/features/auth/domain/repositories/base_auth_repository.dart';

class CheckAuthStatus implements BaseUsecase<User, NoParams> {
  final BaseAuthRepository repository;
  CheckAuthStatus(this.repository);

  @override
  Future<Either<BaseFailure, User>> call(NoParams params) async {
    return await repository.checkAuthStatus();
  }
}
