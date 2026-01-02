import 'package:fpdart/fpdart.dart';

import '../repositories/base_user_repository.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/base_failure.dart';
import '../../../../core/usecases/base_usecase.dart';

class DeleteUser implements BaseUsecase<void, String> {
  final BaseUserRepository repository;

  DeleteUser(this.repository);

  @override
  Future<Either<BaseFailure, void>> call(String id) async {
    try {
      return await repository.deleteUser(id);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
