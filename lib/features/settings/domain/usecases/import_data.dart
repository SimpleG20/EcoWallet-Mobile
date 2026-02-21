import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/base_failure.dart';
import '../../../../core/services/backup_service.dart';
import '../../../wallet/data/datasources/base_wallet_local_data_source.dart';
import '../../../wallet/data/models/transaction_model.dart';
import '../../../wallet/domain/entities/transaction.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/database/db_seeds.dart';

/// Result of an import operation.
class ImportResult {
  final int importedCount;
  final int skippedCount;
  final int errorCount;

  const ImportResult({
    required this.importedCount,
    this.skippedCount = 0,
    this.errorCount = 0,
  });

  int get totalProcessed => importedCount + skippedCount + errorCount;
}

/// Import mode determining how to handle existing data.
enum ImportMode {
  /// Replace all existing data with imported data
  replace,
  /// Merge imported data with existing (skip duplicates)
  merge,
}

/// Use case to import user data from a file.
class ImportData {
  final BackupService _backupService;
  final BaseWalletLocalDataSource _walletDataSource;

  ImportData({
    required BackupService backupService,
    required BaseWalletLocalDataSource walletDataSource,
  })  : _backupService = backupService,
        _walletDataSource = walletDataSource;

  /// Opens file picker and imports data.
  /// 
  /// [userId] - The current user's ID (used when replacing data)
  /// [mode] - Whether to replace or merge with existing data
  /// [password] - Decryption password if file is encrypted
  /// 
  /// Returns import statistics or a failure.
  Future<Either<BaseFailure, ImportResult>> call({
    required String userId,
    required ImportMode mode,
    String? password,
  }) async {
    try {
      // Let user pick file
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select Backup File',
        type: FileType.custom,
        allowedExtensions: ['json', 'ewb'],
      );

      if (result == null || result.files.isEmpty) {
        return Left(CancelledFailure('Import cancelled by user'));
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        return Left(UnknownFailure('Could not read file path'));
      }

      // Read file content
      final file = File(filePath);
      final content = await file.readAsString();

      // Check if encrypted and password is needed
      if (_backupService.isEncrypted(content)) {
        if (password == null || password.isEmpty) {
          return Left(PasswordRequiredFailure('This backup is encrypted. Please provide a password.'));
        }
      }

      // Parse backup data
      final BackupData backupData;
      try {
        backupData = _backupService.importFromJson(content, password: password);
      } on FormatException catch (e) {
        return Left(InvalidBackupFailure(e.message));
      }

      // Validate backup
      if (!_backupService.validateBackup(backupData)) {
        return Left(InvalidBackupFailure('Backup file is invalid or corrupted'));
      }

      // Process import based on mode
      return await _processImport(
        backupData: backupData,
        userId: userId,
        mode: mode,
      );
    } catch (e) {
      return Left(UnknownFailure('Failed to import data: $e'));
    }
  }

  /// Processes the import based on the selected mode.
  Future<Either<BaseFailure, ImportResult>> _processImport({
    required BackupData backupData,
    required String userId,
    required ImportMode mode,
  }) async {
    try {
      if (mode == ImportMode.replace) {
        // Delete all existing transactions first
        await _walletDataSource.deleteAllTransactions(userId);
      }

      // Get existing transaction IDs for duplicate detection
      Set<String> existingIds = {};
      if (mode == ImportMode.merge) {
        final existing = await _walletDataSource.getLastTransactions();
        existingIds = existing.map((t) => t.id).toSet();
      }

      int importedCount = 0;
      int skippedCount = 0;
      int errorCount = 0;

      for (final txJson in backupData.transactions) {
        try {
          final transactionId = txJson['id'] as String;
          
          // Skip duplicates in merge mode
          if (mode == ImportMode.merge && existingIds.contains(transactionId)) {
            skippedCount++;
            continue;
          }

          // Parse and save transaction
          final transaction = _parseTransaction(txJson, userId);
          final model = TransactionModel.fromEntity(transaction);
          await _walletDataSource.cacheTransaction(model);
          importedCount++;
        } catch (e) {
          errorCount++;
        }
      }

      return Right(ImportResult(
        importedCount: importedCount,
        skippedCount: skippedCount,
        errorCount: errorCount,
      ));
    } catch (e) {
      return Left(UnknownFailure('Failed to process import: $e'));
    }
  }

  /// Parses a transaction from JSON map.
  Transaction _parseTransaction(Map<String, dynamic> json, String userId) {
    // Handle type (can be type_id int or type string)
    ETransactionType type;
    final rawType = json['type_id'] ?? json['type'];
    if (rawType is int) {
      type = rawType == 1 ? ETransactionType.income : ETransactionType.expense;
    } else {
      final typeStr = rawType?.toString() ?? 'expense';
      type = typeStr == 'income' ? ETransactionType.income : ETransactionType.expense;
    }

    // Handle category (can be category_id int or category string)
    ETransactionCategory category;
    final rawCategory = json['category_id'] ?? json['category'];
    if (rawCategory is int) {
      final categoryName = DbSeeds.getCategoryName(rawCategory);
      category = ETransactionCategory.values.firstWhere(
        (e) => e.name == categoryName,
        orElse: () => ETransactionCategory.others,
      );
    } else {
      final catStr = rawCategory?.toString() ?? 'others';
      category = ETransactionCategory.values.firstWhere(
        (e) => e.name == catStr || e.toString() == catStr,
        orElse: () => ETransactionCategory.others,
      );
    }

    // Handle amount
    int amountCents;
    if (json.containsKey('amount_cents')) {
      amountCents = json['amount_cents'] as int;
    } else {
      final amount = json['amount'] as int? ?? 0;
      final cents = json['cents'] as int? ?? 0;
      amountCents = amount * 100 + cents;
    }

    return Transaction(
      id: json['id'] as String,
      userId: userId, // Use current user's ID
      name: json['name'] as String,
      amountCents: amountCents,
      date: DateTime.parse(json['date'] as String),
      type: type,
      category: category,
    );
  }
}

/// Failure when password is required for encrypted backup.
class PasswordRequiredFailure extends BaseFailure {
  const PasswordRequiredFailure(super.message);
}

/// Failure when backup format is invalid.
class InvalidBackupFailure extends BaseFailure {
  const InvalidBackupFailure(super.message);
}

/// Failure representing a user cancellation.
class CancelledFailure extends BaseFailure {
  const CancelledFailure(super.message);
}
