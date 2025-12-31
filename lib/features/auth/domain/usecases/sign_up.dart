import 'package:fpdart/fpdart.dart';

import '../entities/sign_up_params.dart';
import '../repositories/base_auth_repository.dart';
import '../../../../core/errors/base_failure.dart';
import '../../../../core/usecases/base_usecase.dart';

class SignUp implements BaseUsecase<void, SignUpParams> {
  final BaseAuthRepository repository;
  SignUp(this.repository);

  @override
  Future<Either<BaseFailure, void>> call(SignUpParams params) async {
    return await repository.signUp(params);
  }
}
