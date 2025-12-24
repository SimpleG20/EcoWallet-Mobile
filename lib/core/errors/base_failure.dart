import 'package:equatable/equatable.dart';

abstract class BaseFailure extends Equatable {
  final String? message;

  const BaseFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Representing errors from the API/Server
class ServerFailure extends BaseFailure {
  const ServerFailure(super.message);
}

/// Representing errors from local cache/storage
class CacheFailure extends BaseFailure {
  const CacheFailure(super.message);
}

/// Representing errors related to network issues
class NetworkFailure extends BaseFailure {
  const NetworkFailure(super.message);
}

/// Representing errors related to authentication
class AuthenticationFailure extends BaseFailure {
  const AuthenticationFailure(super.message);
}

/// Representing invalid data (Business rules violations, etc.)
class ValidationFailure extends BaseFailure {
  const ValidationFailure(super.message);
}

class UnknownFailure extends BaseFailure {
  const UnknownFailure(super.message);
}
