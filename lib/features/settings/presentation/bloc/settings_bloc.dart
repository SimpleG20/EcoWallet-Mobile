import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/user_preferences.dart';
import '../../domain/usecases/get_user_preferences.dart';
import '../../domain/usecases/update_user_preferences.dart';
import '../../data/model/settings_data_model.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/domain/usecases/get_current_user.dart';
import '../../../../core/usecases/base_usecase.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<BaseSettingsEvent, BaseSettingsState> {
  final GetCurrentUser getCurrentUser;
  final GetUserPreferences getUserPreferences;
  final UpdateUserPreferences updateUserPreferences;

  SettingsBloc({
    required this.getCurrentUser,
    required this.getUserPreferences,
    required this.updateUserPreferences,
  }) : super(SettingsInitialState()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateUserPreferencesEvent>(_onUpdateUserPreferences);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<BaseSettingsState> emit,
  ) async {
    emit(SettingsLoadingState());

    final userResult = await getCurrentUser(NoParams());
    switch (userResult) {
      case Left(value: final failure):
        emit(SettingsErrorState(message: failure.message));
        return;
      case Right(value: final user):
        final result = await getUserPreferences(user.id);
        result.fold(
          (failure) {
            emit(SettingsErrorState(message: failure.message));
          },
          (preferences) {
            emit(
              SettingsLoadedState(
                user: user,
                preferences: preferences,
              ),
            );
          },
        );
        return;
    }
  }

  Future<void> _onUpdateUserPreferences(
    UpdateUserPreferencesEvent event,
    Emitter<BaseSettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SettingsLoadedState) {
      emit(SettingsErrorState(message: 'Cannot update preferences when settings are not loaded.'));
      return;
    }

    // Convert entity to model for persistence
    final preferencesModel = UserPreferencesModel.fromEntity(event.userPreferences);

    // Save to database
    final result = await updateUserPreferences(preferencesModel);
    result.fold(
      (failure) {
        emit(SettingsErrorState(message: failure.message));
      },
      (updatedPreferences) {
        emit(PreferencesUpdatedState(preferences: updatedPreferences));
      },
    );
  }
}
