import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/features/user/domain/entities/user.dart';
import 'package:eco_wallet/core/errors/base_failure.dart';

abstract class BaseUserRepository {
  Future<Either<BaseFailure, User>> getCurrentUser();
  Future<Either<BaseFailure, User>> getUser(String id);
  Future<Either<BaseFailure, Unit>> updateUser(User user);
  Future<Either<BaseFailure, Unit>> deleteUser(String id);
}
