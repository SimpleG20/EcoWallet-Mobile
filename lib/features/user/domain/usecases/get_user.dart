import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../entities/user.dart';
import '../repositories/base_user_repository.dart';
import '../../../../core/errors/base_failure.dart';
import '../../../../core/usecases/base_usecase.dart';

class GetUser implements BaseUsecase<User, String> {
  final BaseUserRepository repository;

  GetUser(this.repository);

  @override
  Future<Either<BaseFailure, User>> call(String id) async {
    try {
      return await repository.getUser(id);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
