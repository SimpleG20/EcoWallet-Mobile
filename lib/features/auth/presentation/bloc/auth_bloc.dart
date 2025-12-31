import 'package:eco_wallet/features/auth/domain/usecases/check_auth_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/base_usecase.dart';
import '../../domain/entities/sign_in_params.dart';
import '../../domain/entities/sign_up_params.dart';
import '../../domain/usecases/log_out.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<BaseAuthEvent, BaseAuthState> {
  final SignIn signIn;
  final SignUp signUp;
  final LogOut logOut;
  final CheckAuthStatus checkAuthStatus;

  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.logOut,
    required this.checkAuthStatus,
  }) : super(AuthInitialState()) {
    on<AppStartedEvent>(_onAppStarted);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<LogOutEvent>(_onLogOut);
  }

  Future<void> _onAppStarted(AppStartedEvent event, Emitter<BaseAuthState> emit) async {
    emit(AuthLoadingState());

    final result = await checkAuthStatus(NoParams());

    result.fold(
      (failure) => emit(AuthUnauthenticatedState()),
      (user) => emit(AuthAuthenticatedState(userId: user.id)),
    );
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<BaseAuthState> emit) async {
    emit(AuthLoadingState());

    final result = await checkAuthStatus(NoParams());
    result.fold(
      (failure) => emit(AuthUnauthenticatedState()),
      (user) => emit(AuthAuthenticatedState(userId: user.id)),
    );
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<BaseAuthState> emit) async {
    emit(AuthLoadingState());

    final result = await signIn(SignInParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(AuthAuthenticatedState(userId: user.id)),
    );
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<BaseAuthState> emit) async {
    emit(AuthLoadingState());

    final result = await signUp(SignUpParams(
      name: event.name,
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (_) => emit(AuthAuthenticatedState(userId: '')), // User created, trigger re-check
    );
  }

  Future<void> _onLogOut(LogOutEvent event, Emitter<BaseAuthState> emit) async {
    emit(AuthLoadingState());

    final result = await logOut(NoParams());

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (_) => emit(AuthUnauthenticatedState()),
    );
  }
}

