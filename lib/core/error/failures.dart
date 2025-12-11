import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  const Failure([this.message]);

  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Database related failures
class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message]);
}

/// Cache related failures
class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure([super.message]);
}

/// Server related failures (for future API integration)
class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

/// Network related failures (for future API integration)
class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

/// Unexpected failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message]);
}
