import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:fpdart/fpdart.dart';

import '../model/user_model.dart';
import '../datasources/base_user_data_source.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/base_user_repository.dart';

class UserRepositoryImpl implements BaseUserRepository {
  final BaseUserDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<Either<BaseFailure, User>> getUser() async {
    try {
      final user = await dataSource.getUser();
      return Right(user);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<BaseFailure, Unit>> updateUser(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await dataSource.updateUser(userModel);
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
