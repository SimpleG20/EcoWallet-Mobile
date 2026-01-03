import 'package:eco_wallet/features/settings/domain/entities/data_preferences.dart';
import 'package:eco_wallet/features/settings/domain/enums/backup_frequency.dart';

class DataPreferencesModel extends DataPreferences {
  const DataPreferencesModel({
    required super.cloudBackupEnabled,
    required super.encryptedBackup,
    required super.backupFrequency,
    super.lastBackupDate,
  });

  factory DataPreferencesModel.defaults() {
    return const DataPreferencesModel(
      cloudBackupEnabled: false,
      encryptedBackup: false,
      backupFrequency: BackupFrequency.weekly,
    );
  }

  factory DataPreferencesModel.fromJson(Map<String, dynamic> json) {
    DateTime? lastBackup;
    if (json['lastBackupDate'] != null) {
      lastBackup = DateTime.tryParse(json['lastBackupDate'].toString());
    }

    return DataPreferencesModel(
      cloudBackupEnabled: _parseBool(json['cloudBackupEnabled'], false),
      encryptedBackup: _parseBool(json['encryptedBackup'], false),
      backupFrequency: BackupFrequency.fromString(json['backupFrequency']?.toString() ?? 'weekly'),
      lastBackupDate: lastBackup,
    );
  }

  /// Parses a boolean value from JSON that may be a bool, int (0/1), or string.
  static bool _parseBool(dynamic value, bool defaultValue) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return int.tryParse(value) == 1 || value.toLowerCase() == 'true';
    return defaultValue;
  }

  static Map<String, dynamic> toJson(DataPreferences preferences) {
    return {
      'cloudBackupEnabled': preferences.cloudBackupEnabled,
      'encryptedBackup': preferences.encryptedBackup,
      'backupFrequency': preferences.backupFrequency.name,
      'lastBackupDate': preferences.lastBackupDate?.toIso8601String(),
    };
  }
}

