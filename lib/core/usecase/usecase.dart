import 'package:fpdart/fpdart.dart';
import 'package:ecowallet/core/error/failures.dart';

/// Base class for all use cases
/// 
/// [Type] is the type of the return value
/// [Params] is the type of the parameters
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Used when a use case doesn't require parameters
class NoParams {
  const NoParams();
}
