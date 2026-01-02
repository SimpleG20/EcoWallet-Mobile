import 'package:eco_wallet/features/settings/domain/entities/data_preferences.dart';
import 'package:eco_wallet/features/settings/domain/enums/backup_frequency.dart';

class DataPreferencesModel extends DataPreferences {
  const DataPreferencesModel({
    required super.cloudBackupEnabled,
    required super.encryptedBackup,
    required super.backupFrequency,
  });

  factory DataPreferencesModel.defaults() {
    return const DataPreferencesModel(
      cloudBackupEnabled: false,
      encryptedBackup: false,
      backupFrequency: BackupFrequency.weekly,
    );
  }

  factory DataPreferencesModel.fromJson(Map<String, dynamic> json) {
    return DataPreferencesModel(
      cloudBackupEnabled: int.tryParse(json['cloudBackupEnabled']) == 1,
      encryptedBackup: int.tryParse(json['encryptedBackup']) == 1,
      backupFrequency: BackupFrequency.fromString(json['backupFrequency']),
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
