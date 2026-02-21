import 'package:fpdart/fpdart.dart';

import '../entities/user.dart';
import '../../../../core/errors/base_failure.dart';

abstract class BaseUserRepository {
  Future<Either<BaseFailure, User>> getCurrentUser();
  Future<Either<BaseFailure, User>> getUser(String id);
  Future<Either<BaseFailure, Unit>> updateUser(User user);
  Future<Either<BaseFailure, Unit>> deleteUser(String id);
}
