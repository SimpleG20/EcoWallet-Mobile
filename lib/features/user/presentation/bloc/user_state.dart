part of 'user_bloc.dart';

abstract class BaseUserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitialState extends BaseUserState {}

class UserLoadingState extends BaseUserState {}

class UserLoadedState extends BaseUserState {
  final User user; // Replace dynamic with your User entity type

  UserLoadedState({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserErrorState extends BaseUserState {
  final String? message;

  UserErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
