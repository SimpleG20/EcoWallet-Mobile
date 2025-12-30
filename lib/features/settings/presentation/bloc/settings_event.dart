part of 'settings_bloc.dart';

abstract class BaseSettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends BaseSettingsEvent {}

class LoadedSettingsEvent extends BaseSettingsEvent {
  final User personalPreferences;
  final DataPreferences dataPreferences;
  final BudgetPreferences budgetPreferences;
  final AppearancePreferences appearancePreferences;
  final NotificationPreferences notificationPreferences;

  LoadedSettingsEvent({
    required this.personalPreferences,
    required this.dataPreferences,
    required this.appearancePreferences,
    required this.budgetPreferences,
    required this.notificationPreferences,
  });

  @override
  List<Object?> get props => [
        personalPreferences,
        dataPreferences,
        appearancePreferences,
        budgetPreferences,
        notificationPreferences,
      ];
}

class UserPreferencesLoadedEvent extends BaseSettingsEvent {
  final UserPreferences userPreferences;

  UserPreferencesLoadedEvent({required this.userPreferences});

  @override
  List<Object?> get props => [userPreferences];
}

class UpdateUserPreferencesEvent extends BaseSettingsEvent {
  final UserPreferences userPreferences;

  UpdateUserPreferencesEvent({required this.userPreferences});

  @override
  List<Object?> get props => [userPreferences];
}
