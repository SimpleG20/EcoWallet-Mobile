/// Represents the app's theme mode preference.
enum AppThemeMode {
  /// Follow system theme setting.
  system,

  /// Always use light theme.
  light,

  /// Always use dark theme.
  dark;

  static AppThemeMode fromString(String themeMode) {
    switch (themeMode) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
      default:
        return AppThemeMode.system;
    }
  }
}
