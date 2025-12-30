part of 'settings_bloc.dart';

abstract class BaseSettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends BaseSettingsState {}

class SettingsLoading extends BaseSettingsState {}

class SettingsError extends BaseSettingsState {
  final String? message;

  SettingsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class SettingsLoaded extends BaseSettingsState {
  final User user;
  final BudgetPreferences? budgetPreferences;
  final AppearancePreferences? appearancePreferences;
  final NotificationPreferences? notificationPreferences;
  final String? currentPassword;

  SettingsLoaded({
    required this.user,
    this.budgetPreferences,
    this.appearancePreferences,
    this.notificationPreferences,
    this.currentPassword,
  });

  @override
  List<Object?> get props => [
        user,
        budgetPreferences,
        appearancePreferences,
        notificationPreferences,
      ];

  SettingsLoaded copyWith({
    User? user,
    BudgetPreferences? budgetPreferences,
    AppearancePreferences? appearancePreferences,
    NotificationPreferences? notificationPreferences,
  }) {
    return SettingsLoaded(
      user: user ?? this.user,
      budgetPreferences: budgetPreferences ?? this.budgetPreferences,
      appearancePreferences: appearancePreferences ?? this.appearancePreferences,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
    );
  }
}
