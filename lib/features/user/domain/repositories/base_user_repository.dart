import 'package:fpdart/fpdart.dart';

import '../entities/user.dart';
import '../../../../core/errors/base_failure.dart';

abstract class BaseUserRepository {
  Future<Either<BaseFailure, User>> getUser();
  Future<Either<BaseFailure, Unit>> updateUser(User user);
}
