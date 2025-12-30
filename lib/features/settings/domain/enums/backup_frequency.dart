/// Backup frequency for cloud sync.
enum BackupFrequency {
  /// No automatic backup.
  none,

  /// Backup daily.
  daily,

  /// Backup weekly.
  weekly,

  /// Backup monthly.
  monthly;

  static BackupFrequency fromString(String json) {
    return BackupFrequency.values.firstWhere(
      (e) => e.toString().split('.').last == json,
      orElse: () => BackupFrequency.none,
    );
  }
}
