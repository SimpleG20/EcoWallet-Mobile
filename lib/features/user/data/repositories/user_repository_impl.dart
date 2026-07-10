import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/errors/exceptions.dart';
import 'package:eco_wallet/features/auth/data/datasources/base_auth_data_source.dart';
import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/features/user/data/model/user_model.dart';
import 'package:eco_wallet/features/user/data/datasources/base_user_data_source.dart';
import 'package:eco_wallet/features/user/domain/entities/user.dart';
import 'package:eco_wallet/features/user/domain/repositories/base_user_repository.dart';

class UserRepositoryImpl implements BaseUserRepository {
  final BaseUserDataSource dataSource;
  final BaseAuthDataSource authDataSource;

  UserRepositoryImpl({required this.dataSource, required this.authDataSource});

  @override
  Future<Either<BaseFailure, User>> getCurrentUser() async {
    try {
      final user = await authDataSource.getLoggedUser();
      return Right(user);
    } on CacheException {
      return Left(CacheFailure("Failed to fetch current user from cache"));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<BaseFailure, User>> getUser(String id) async {
    try {
      final user = await dataSource.getUser(id);
      return Right(user);
    } on CacheException {
      return Left(CacheFailure("Failed to fetch user from cache"));
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
    } on CacheException {
      return Left(CacheFailure("Failed to update user in cache"));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<BaseFailure, Unit>> deleteUser(String id) async {
    try {
      await dataSource.deleteUser(id);
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure("Failed to delete user from cache"));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
