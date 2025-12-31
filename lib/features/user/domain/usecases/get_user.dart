import 'package:fpdart/fpdart.dart';

import '../entities/user.dart';
import '../repositories/base_user_repository.dart';
import '../../../../core/errors/base_failure.dart';
import '../../../../core/usecases/base_usecase.dart';

class GetUser implements BaseUsecase<User, String> {
  final BaseUserRepository repository;

  GetUser(this.repository);

  @override
  Future<Either<BaseFailure, User>> call(String id) async {
    return await repository.getUser(id);
  }
}
