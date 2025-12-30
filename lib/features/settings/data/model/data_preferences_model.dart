import 'package:eco_wallet/features/settings/domain/entities/data_preferences.dart';
import 'package:eco_wallet/features/settings/domain/enums/backup_frequency.dart';

class DataPreferencesModel extends DataPreferences {
  const DataPreferencesModel({
    required super.cloudBackupEnabled,
    required super.encryptedBackup,
    required super.backupFrequency,
  });

  factory DataPreferencesModel.fromJson(Map<String, dynamic> json) {
    return DataPreferencesModel(
      cloudBackupEnabled: json['cloudBackupEnabled'] as bool,
      encryptedBackup: json['encryptedBackup'] as bool,
      backupFrequency: BackupFrequency.fromString(json['backupFrequency'] as String),
    );
  }

  static Map<String, dynamic> toJson(DataPreferences preferences) {
    return {
      'cloudBackupEnabled': preferences.cloudBackupEnabled,
      'encryptedBackup': preferences.encryptedBackup,
      'backupFrequency': preferences.backupFrequency.name,
    };
  }
}
