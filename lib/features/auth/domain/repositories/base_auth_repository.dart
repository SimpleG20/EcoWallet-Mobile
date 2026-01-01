import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/base_failure.dart';
import '../../../user/domain/entities/user.dart';
import '../entities/sign_in_params.dart';
import '../entities/sign_up_params.dart';

abstract class BaseAuthRepository {
  Future<Either<BaseFailure, User>> signIn(SignInParams params);
  Future<Either<BaseFailure, User>> signUp(SignUpParams params);
  Future<Either<BaseFailure, User>> checkAuthStatus();
  Future<Either<BaseFailure, User>> getCurrentSessionUser();
  Future<Either<BaseFailure, Unit>> logOut();
}
