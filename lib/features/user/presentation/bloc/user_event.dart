part of 'user_bloc.dart';

abstract class BaseUserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends BaseUserEvent {
  final String id;

  LoadUserEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class UpdateUserEvent extends BaseUserEvent {
  final User user;

  UpdateUserEvent({required this.user});
  @override
  List<Object?> get props => [user];
}

class DeleteUserEvent extends BaseUserEvent {
  final String id;

  DeleteUserEvent({required this.id});
  @override
  List<Object?> get props => [id];
}
