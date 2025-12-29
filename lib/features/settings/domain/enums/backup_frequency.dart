/// Backup frequency for cloud sync.
enum BackupFrequency {
  /// No automatic backup.
  none,

  /// Backup daily.
  daily,

  /// Backup weekly.
  weekly,

  /// Backup monthly.
  monthly,
}

extension BackupFrequencyX on BackupFrequency {
  String get displayName {
    switch (this) {
      case BackupFrequency.none:
        return 'Never';
      case BackupFrequency.daily:
        return 'Daily';
      case BackupFrequency.weekly:
        return 'Weekly';
      case BackupFrequency.monthly:
        return 'Monthly';
    }
  }
}
