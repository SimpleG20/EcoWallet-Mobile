import 'package:equatable/equatable.dart';

import '../enums/settings_enums.dart';

/// Entity representing data management preferences.
class DataPreferences extends Equatable {
  final bool cloudBackupEnabled;
  final bool encryptedBackup;
  final BackupFrequency backupFrequency;

  const DataPreferences({
    this.cloudBackupEnabled = true,
    this.encryptedBackup = false,
    this.backupFrequency = BackupFrequency.daily,
  });

  factory DataPreferences.defaults() {
    return const DataPreferences();
  }

  DataPreferences copyWith({
    bool? cloudBackupEnabled,
    bool? encryptedBackup,
    BackupFrequency? backupFrequency,
  }) {
    return DataPreferences(
      cloudBackupEnabled: cloudBackupEnabled ?? this.cloudBackupEnabled,
      encryptedBackup: encryptedBackup ?? this.encryptedBackup,
      backupFrequency: backupFrequency ?? this.backupFrequency,
    );
  }

  @override
  List<Object?> get props => [
        cloudBackupEnabled,
        encryptedBackup,
        backupFrequency,
      ];
}
