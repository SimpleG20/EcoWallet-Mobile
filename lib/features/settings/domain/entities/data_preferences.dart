import 'package:equatable/equatable.dart';

import '../enums/settings_enums.dart';

/// Entity representing data management preferences.
class DataPreferences extends Equatable {
  final bool cloudBackupEnabled;
  final bool encryptedBackup;
  final BackupFrequency backupFrequency;
  final DateTime? lastBackupDate;

  const DataPreferences({
    this.cloudBackupEnabled = false,
    this.encryptedBackup = false,
    this.backupFrequency = BackupFrequency.none,
    this.lastBackupDate,
  });

  DataPreferences copyWith({
    bool? cloudBackupEnabled,
    bool? encryptedBackup,
    BackupFrequency? backupFrequency,
    DateTime? lastBackupDate,
  }) {
    return DataPreferences(
      cloudBackupEnabled: cloudBackupEnabled ?? this.cloudBackupEnabled,
      encryptedBackup: encryptedBackup ?? this.encryptedBackup,
      backupFrequency: backupFrequency ?? this.backupFrequency,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
    );
  }

  @override
  List<Object?> get props => [
        cloudBackupEnabled,
        encryptedBackup,
        backupFrequency,
        lastBackupDate,
      ];
}

