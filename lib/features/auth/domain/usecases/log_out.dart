import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/features/auth/domain/repositories/base_auth_repository.dart';

class LogOut implements BaseUsecase<void, NoParams> {
  final BaseAuthRepository repository;
  LogOut(this.repository);

  @override
  Future<Either<BaseFailure, void>> call(NoParams params) async {
    return await repository.logOut();
  }
}

