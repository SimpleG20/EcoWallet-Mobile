part of 'auth_bloc.dart';

abstract class BaseAuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Dispatched when the app starts to check authentication status.
class AppStartedEvent extends BaseAuthEvent {}

/// Dispatched when user attempts to sign in.
class SignInEvent extends BaseAuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Dispatched when user attempts to sign up.
class SignUpEvent extends BaseAuthEvent {
  final String name;
  final String email;
  final String password;

  SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

/// Dispatched when user logs out.
class LogOutEvent extends BaseAuthEvent {}

/// Dispatched to re-check authentication status.
class CheckAuthStatusEvent extends BaseAuthEvent {}

