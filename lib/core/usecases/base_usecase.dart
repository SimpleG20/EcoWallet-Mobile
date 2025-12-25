import 'package:fpdart/fpdart.dart';
import 'package:eco_wallet/core/errors/base_failure.dart';

abstract class BaseUsecase<Type, Params> {
  Future<Either<BaseFailure, Type>> call(Params params);
}

class NoParams {}
