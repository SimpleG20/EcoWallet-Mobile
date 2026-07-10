import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/features/user/domain/repositories/base_user_repository.dart';
import 'package:eco_wallet/core/errors/exceptions.dart';
import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';

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
