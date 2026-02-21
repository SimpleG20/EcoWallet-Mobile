part of 'auth_bloc.dart';

abstract class BaseAuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends BaseAuthState {}

class AuthLoadingState extends BaseAuthState {}

class AuthAuthenticatedState extends BaseAuthState {
  final String userId;

  AuthAuthenticatedState({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class AuthUnauthenticatedState extends BaseAuthState {}

class AuthErrorState extends BaseAuthState {
  final String? message;

  AuthErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
