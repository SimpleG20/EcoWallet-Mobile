import 'package:eco_wallet/features/settings/domain/usecases/get_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/base_usecase.dart';
import '../../domain/entities/data_preferences.dart';
import '../../domain/entities/budget_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/appearance_preferences.dart';
import '../../domain/entities/notification_preferences.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/usecases/get_user_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<BaseSettingsEvent, BaseSettingsState> {
  final GetUser getUser;
  final GetUserPreferences getUserPreferences;

  SettingsBloc({
    required this.getUser,
    required this.getUserPreferences,
  }) : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<LoadedSettingsEvent>(_onLoadedSettingsEvent);
    on<UserPreferencesLoadedEvent>(_onUpdateDataSettings);
    on<UpdateUserPreferencesEvent>(_onUpdateUserPreferences);
  }

  Future<void> _onLoadSettings(LoadSettingsEvent event, Emitter<BaseSettingsState> emit) async {
    emit(SettingsLoading());

    final userResult = await getUser(NoParams());
    userResult.fold(
      (failure) async {
        emit(SettingsError(message: failure.message));
      },
      (user) async {
        final result = await getUserPreferences(NoParams());
        result.fold(
          (failure) async {
            emit(SettingsError(message: failure.message));
          },
          (settings) async {
            emit(SettingsLoaded(
              user: user,
              appearancePreferences: settings.appearancePreferences,
              budgetPreferences: settings.budgetPreferences,
              notificationPreferences: settings.notificationPreferences,
            ));
          },
        );
      },
    );
  }

  Future<void> _onLoadedSettingsEvent(LoadedSettingsEvent event, Emitter<BaseSettingsState> emit) async {
    emit(SettingsLoading());
    final userResult = await getUser(NoParams());
    userResult.fold(
      (failure) async {
        emit(SettingsError(message: failure.message));
      },
      (user) async {
        final result = await getUserPreferences(NoParams());
        result.fold(
          (failure) async {
            emit(SettingsError(message: failure.message));
          },
          (settings) async {
            emit(SettingsLoaded(
              user: user,
              appearancePreferences: settings.appearancePreferences,
              budgetPreferences: settings.budgetPreferences,
              notificationPreferences: settings.notificationPreferences,
            ));
          },
        );
      },
    );
  }

  Future<void> _onUpdateDataSettings(UserPreferencesLoadedEvent event, Emitter<BaseSettingsState> emit) async {
    emit(SettingsLoading());

    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(SettingsLoaded(
        user: currentState.user,
        appearancePreferences: event.userPreferences.appearancePreferences,
        budgetPreferences: event.userPreferences.budgetPreferences,
        notificationPreferences: event.userPreferences.notificationPreferences,
      ));
    }
  }

  Future<void> _onUpdateUserPreferences(UpdateUserPreferencesEvent event, Emitter<BaseSettingsState> emit) async {
    emit(SettingsLoading());

    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      emit(SettingsLoaded(
        user: currentState.user,
        appearancePreferences: event.userPreferences.appearancePreferences,
        budgetPreferences: event.userPreferences.budgetPreferences,
        notificationPreferences: event.userPreferences.notificationPreferences,
      ));
    }
  }
}
