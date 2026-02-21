import 'package:fpdart/fpdart.dart';

import '../entities/user.dart';
import '../repositories/base_user_repository.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/base_failure.dart';
import '../../../../core/usecases/base_usecase.dart';

class GetCurrentUser implements BaseUsecase<User, NoParams> {
  final BaseUserRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<BaseFailure, User>> call(NoParams params) async {
    try {
      return await repository.getCurrentUser();
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
