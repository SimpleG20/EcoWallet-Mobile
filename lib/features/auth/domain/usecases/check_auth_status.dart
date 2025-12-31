import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/base_failure.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../../../user/domain/entities/user.dart';
import '../repositories/base_auth_repository.dart';

class CheckAuthStatus implements BaseUsecase<User, NoParams> {
  final BaseAuthRepository repository;
  CheckAuthStatus(this.repository);

  @override
  Future<Either<BaseFailure, User>> call(NoParams params) async {
    return await repository.checkAuthStatus();
  }
}
