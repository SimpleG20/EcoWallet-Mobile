part of 'settings_bloc.dart';

abstract class BaseSettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsInitialState extends BaseSettingsState {}

class SettingsLoadingState extends BaseSettingsState {}

class SettingsErrorState extends BaseSettingsState {
  final String? message;

  SettingsErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class SettingsLoadedState extends BaseSettingsState {
  final User user;
  final UserPreferences preferences;

  SettingsLoadedState({
    required this.user,
    required this.preferences,
  });

  @override
  List<Object?> get props => [
        user,
        preferences,
      ];

  SettingsLoadedState copyWith({
    User? user,
    UserPreferences? preferences,
  }) {
    return SettingsLoadedState(
      user: user ?? this.user,
      preferences: preferences ?? this.preferences,
    );
  }
}

class PreferencesUpdatedState extends BaseSettingsState {
  final UserPreferences preferences;

  PreferencesUpdatedState({required this.preferences});

  @override
  List<Object?> get props => [preferences];
}
