import 'package:flutter/foundation.dart';

import '../../../features/settings/domain/entities/data_preferences.dart';
import '../../../features/wallet/data/models/transaction_model.dart';
import '../../../features/wallet/domain/entities/transaction.dart';
import 'backup_scheduler.dart';
import 'backup_service.dart';

/// Service that handles automatic backup on app startup.
/// Checks if backup is due based on user preferences and triggers backup if needed.
class AutoBackupService {
  final BackupScheduler _scheduler;

  AutoBackupService({BackupScheduler? scheduler})
      : _scheduler = scheduler ??
            BackupScheduler(backupService: BackupService());

  /// Checks and performs automatic backup if due.
  /// Should be called after user authentication and settings are loaded.
  ///
  /// Returns the backup file path if backup was performed, null otherwise.
  Future<String?> checkAndPerformBackupIfDue({
    required String userId,
    required List<Transaction> transactions,
    required DataPreferences dataPreferences,
  }) async {
    try {
      // Check if backup is due based on frequency
      if (!await _scheduler.isBackupDue(dataPreferences.backupFrequency)) {
        debugPrint('[AutoBackup] Backup not due yet');
        return null;
      }

      debugPrint('[AutoBackup] Backup is due, performing backup...');

      // Convert transactions to JSON format
      final transactionMaps = transactions
          .map((t) => TransactionModel.fromEntity(t).toJson())
          .toList();

      // Perform backup (encrypted if user preference is set)
      final filePath = await _scheduler.performBackup(
        userId: userId,
        transactions: transactionMaps,
        password: dataPreferences.encryptedBackup ? _generateAutoBackupPassword(userId) : null,
      );

      debugPrint('[AutoBackup] Backup completed: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('[AutoBackup] Backup failed: $e');
      return null;
    }
  }

  /// Gets the last backup date.
  Future<DateTime?> getLastBackupDate() async {
    return await _scheduler.getLastBackupDate();
  }

  /// Generates a deterministic password for auto-backups based on userId.
  /// Note: For manual exports, user provides their own password.
  String _generateAutoBackupPassword(String userId) {
    // Use a simple hash of userId for auto-backup password
    // This is only for local auto-backups, not for shared exports
    return 'auto_${userId.hashCode.abs()}';
  }
}
