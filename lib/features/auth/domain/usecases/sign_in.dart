import 'package:eco_wallet/features/auth/domain/entities/sign_in_params.dart';
import 'package:fpdart/fpdart.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';

import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/features/user/domain/entities/user.dart';
import 'package:eco_wallet/features/auth/domain/repositories/base_auth_repository.dart';

class SignIn implements BaseUsecase<User, SignInParams> {
  final BaseAuthRepository repository;

  SignIn(this.repository);

  @override
  Future<Either<BaseFailure, User>> call(SignInParams params) async {
    return await repository.signIn(params);
  }
}
