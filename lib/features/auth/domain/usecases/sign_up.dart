import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/features/auth/domain/entities/sign_up_params.dart';
import 'package:eco_wallet/features/auth/domain/repositories/base_auth_repository.dart';
import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';

class SignUp implements BaseUsecase<void, SignUpParams> {
  final BaseAuthRepository repository;
  SignUp(this.repository);

  @override
  Future<Either<BaseFailure, void>> call(SignUpParams params) async {
    return await repository.signUp(params);
  }
}
