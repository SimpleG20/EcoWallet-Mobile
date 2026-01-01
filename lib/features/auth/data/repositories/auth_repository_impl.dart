import 'package:fpdart/fpdart.dart';

import 'package:uuid/uuid.dart';

import '../datasources/base_auth_data_source.dart';
import '../../domain/entities/sign_in_params.dart';
import '../../domain/entities/sign_up_params.dart';
import '../../domain/repositories/base_auth_repository.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/data/model/user_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/base_failure.dart';

class AuthRepositoryImpl implements BaseAuthRepository {
  final BaseAuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<BaseFailure, User>> signUp(SignUpParams params) async {
    try {
      final newUser = UserModel(
        id: const Uuid().v4(),
        fullName: params.name,
        email: params.email,
        password: params.password,
        phoneNumber: null,
        imageUrl: null,
        address: null,
        dateOfBirth: null,
      );

      await dataSource.registerUser(newUser);
      await dataSource.saveSession(newUser);

      return Right(newUser);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<BaseFailure, User>> signIn(SignInParams params) async {
    try {
      final userModel = await dataSource.authenticate(params.email, params.password);
      await dataSource.saveSession(userModel);

      return Right(userModel);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<BaseFailure, User>> checkAuthStatus() async {
    try {
      final userModel = await dataSource.getLoggedUser();
      return Right(userModel);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<BaseFailure, User>> getCurrentSessionUser() async {
    try {
      final user = await dataSource.getLoggedUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<BaseFailure, Unit>> logOut() async {
    try {
      await dataSource.deleteSession();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
