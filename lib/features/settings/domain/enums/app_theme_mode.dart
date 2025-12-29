/// Represents the app's theme mode preference.
enum AppThemeMode {
  /// Follow system theme setting.
  system,

  /// Always use light theme.
  light,

  /// Always use dark theme.
  dark,
}

extension AppThemeModeX on AppThemeMode {
  String get displayName {
    switch (this) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }
}
