part of 'settings_bloc.dart';

abstract class BaseSettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends BaseSettingsEvent {}

class UpdateUserPreferencesEvent extends BaseSettingsEvent {
  final UserPreferences userPreferences;

  UpdateUserPreferencesEvent({required this.userPreferences});

  @override
  List<Object?> get props => [userPreferences];
}
