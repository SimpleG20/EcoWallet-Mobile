import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/delete_user.dart';
import '../../domain/usecases/update_user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

part 'user_state.dart';
part 'user_event.dart';

class UserBloc extends Bloc<BaseUserEvent, BaseUserState> {
  final GetUser getUser;
  final UpdateUser updateUser;
  final DeleteUser deleteUser;

  final AuthBloc _authBloc;

  UserBloc({
    required this.getUser,
    required this.updateUser,
    required this.deleteUser,
    required AuthBloc authBloc,
  })  : _authBloc = authBloc,
        super(UserInitialState()) {
    on<LoadUserEvent>(_onLoadUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<BaseUserState> emit) async {
    emit(UserLoadingState());
    final result = await getUser(event.id);
    result.fold(
      (failure) => emit(UserErrorState(message: failure.message)),
      (user) => emit(UserLoadedState(user: user)),
    );
  }

  Future<void> _onUpdateUser(UpdateUserEvent event, Emitter<BaseUserState> emit) async {
    emit(UserLoadingState());
    final result = await updateUser(event.user);
    result.fold(
      (failure) => emit(UserErrorState(message: failure.message)),
      (_) => emit(UserLoadedState(user: event.user)),
    );
  }

  Future<void> _onDeleteUser(DeleteUserEvent event, Emitter<BaseUserState> emit) async {
    emit(UserLoadingState());

    final result = await deleteUser(event.id);
    result.fold(
      (failure) => emit(UserErrorState(message: failure.message)),
      (_) {
        _authBloc.add(LogOutEvent());
        emit(UserInitialState());
      },
    );
  }
}
