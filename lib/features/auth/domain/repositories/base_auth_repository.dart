import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/features/user/domain/entities/user.dart';
import 'package:eco_wallet/features/auth/domain/entities/sign_in_params.dart';
import 'package:eco_wallet/features/auth/domain/entities/sign_up_params.dart';

abstract class BaseAuthRepository {
  Future<Either<BaseFailure, User>> signIn(SignInParams params);
  Future<Either<BaseFailure, User>> signUp(SignUpParams params);
  Future<Either<BaseFailure, User>> checkAuthStatus();
  Future<Either<BaseFailure, User>> getCurrentSessionUser();
  Future<Either<BaseFailure, Unit>> logOut();
}
