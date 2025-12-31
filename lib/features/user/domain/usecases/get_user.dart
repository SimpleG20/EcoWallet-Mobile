import 'package:fpdart/fpdart.dart';

import '../entities/user.dart';
import '../repositories/base_user_repository.dart';
import '../../../../core/errors/base_failure.dart';
import '../../../../core/usecases/base_usecase.dart';

class GetUser implements BaseUsecase<User, NoParams> {
  final BaseUserRepository repository;

  GetUser(this.repository);

  @override
  Future<Either<BaseFailure, User>> call(NoParams params) async {
    return await repository.getUser();
  }
}
