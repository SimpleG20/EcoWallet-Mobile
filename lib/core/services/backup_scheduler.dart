import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/settings/domain/enums/backup_frequency.dart';
import 'backup_service.dart';

/// Service responsible for scheduling and executing automatic backups
/// based on user-configured frequency.
class BackupScheduler {
  static const String _lastBackupKey = 'last_backup_date';
  static const String _backupFolderName = 'backups';

  final BackupService _backupService;

  BackupScheduler({required BackupService backupService})
      : _backupService = backupService;

  /// Checks if a backup is due based on the configured frequency.
  /// Returns true if backup should be performed.
  Future<bool> isBackupDue(BackupFrequency frequency) async {
    if (frequency == BackupFrequency.none) return false;

    final lastBackup = await getLastBackupDate();
    if (lastBackup == null) return true; // Never backed up

    final now = DateTime.now();
    final difference = now.difference(lastBackup);

    switch (frequency) {
      case BackupFrequency.daily:
        return difference.inDays >= 1;
      case BackupFrequency.weekly:
        return difference.inDays >= 7;
      case BackupFrequency.monthly:
        return difference.inDays >= 30;
      case BackupFrequency.none:
        return false;
    }
  }

  /// Performs an automatic backup if due.
  /// Returns the backup file path if backup was created, null otherwise.
  Future<String?> performAutoBackupIfDue({
    required BackupFrequency frequency,
    required String userId,
    required List<Map<String, dynamic>> transactions,
    Map<String, dynamic>? settings,
    String? encryptionPassword,
  }) async {
    if (!await isBackupDue(frequency)) return null;

    return await performBackup(
      userId: userId,
      transactions: transactions,
      settings: settings,
      password: encryptionPassword,
    );
  }

  /// Performs a backup and saves it to local storage.
  /// Returns the file path of the created backup.
  Future<String> performBackup({
    required String userId,
    required List<Map<String, dynamic>> transactions,
    Map<String, dynamic>? settings,
    String? password,
  }) async {
    final backupData = _backupService.exportToJson(
      userId: userId,
      transactions: transactions,
      settings: settings,
      password: password,
    );

    final filePath = await _saveBackupToFile(backupData, userId);
    await _updateLastBackupDate();

    return filePath;
  }

  /// Gets the last backup date from preferences.
  Future<DateTime?> getLastBackupDate() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastBackupKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Gets the backup directory path.
  Future<Directory> getBackupDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${appDir.path}/$_backupFolderName');
    
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    
    return backupDir;
  }

  /// Lists all available backup files.
  Future<List<FileSystemEntity>> listBackups() async {
    final backupDir = await getBackupDirectory();
    if (!await backupDir.exists()) return [];
    
    return backupDir
        .listSync()
        .where((entity) => entity.path.endsWith('.json') || entity.path.endsWith('.ewb'))
        .toList()
      ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
  }

  /// Deletes old backups, keeping only the most recent [keepCount].
  Future<void> cleanupOldBackups({int keepCount = 5}) async {
    final backups = await listBackups();
    
    if (backups.length <= keepCount) return;
    
    for (var i = keepCount; i < backups.length; i++) {
      await backups[i].delete();
    }
  }

  // ============ PRIVATE METHODS ============

  Future<String> _saveBackupToFile(String data, String userId) async {
    final backupDir = await getBackupDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final extension = data.startsWith('EW_ENCRYPTED:') ? 'ewb' : 'json';
    final fileName = 'backup_$timestamp.$extension';
    final file = File('${backupDir.path}/$fileName');
    
    await file.writeAsString(data);
    
    // Clean up old backups
    await cleanupOldBackups();
    
    return file.path;
  }

  Future<void> _updateLastBackupDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastBackupKey, DateTime.now().millisecondsSinceEpoch);
  }
}
