import 'package:equatable/equatable.dart';

import '../enums/settings_enums.dart';

/// Entity representing data management preferences.
class DataPreferences extends Equatable {
  final bool cloudBackupEnabled;
  final bool encryptedBackup;
  final BackupFrequency backupFrequency;

  const DataPreferences({
    required this.cloudBackupEnabled,
    required this.encryptedBackup,
    required this.backupFrequency,
  });

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
