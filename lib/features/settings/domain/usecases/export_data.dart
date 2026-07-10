import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/services/backup_service.dart';
import 'package:eco_wallet/features/wallet/data/datasources/base_wallet_local_data_source.dart';

/// Use case to export user data to a file.
///
/// Exports all transactions to a JSON file, optionally encrypted.
/// Uses FilePicker to let user choose save location.
class ExportData {
  final BackupService _backupService;
  final BaseWalletLocalDataSource _walletDataSource;

  ExportData({
    required BackupService backupService,
    required BaseWalletLocalDataSource walletDataSource,
  })  : _backupService = backupService,
        _walletDataSource = walletDataSource;

  /// Exports user data to a file.
  ///
  /// [userId] - The current user's ID
  /// [password] - Optional encryption password (null = no encryption)
  ///
  /// Returns the file path where data was saved, or a failure.
  Future<Either<BaseFailure, String>> call({
    required String userId,
    String? password,
  }) async {
    try {
      // Get all transactions
      final transactions = await _walletDataSource.getLastTransactions();
      final transactionMaps = transactions.map((t) => t.toJson()).toList();

      // Generate backup data
      final backupJson = _backupService.exportToJson(
        userId: userId,
        transactions: transactionMaps,
        password: password,
      );

      // Determine file extension based on encryption
      final isEncrypted = password != null && password.isNotEmpty;
      final extension = isEncrypted ? 'ewb' : 'json';
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final fileName = 'ecowallet_backup_$timestamp.$extension';

      // Let user choose save location
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: [extension],
        bytes: null, // We'll write manually for better control
      );

      if (result == null) {
        return Left(CancelledFailure('Export cancelled by user'));
      }

      // Write file
      final file = File(result);
      await file.writeAsString(backupJson);

      return Right(result);
    } catch (e) {
      return Left(UnknownFailure('Failed to export data: $e'));
    }
  }
}

/// Failure representing a user cancellation.
class CancelledFailure extends BaseFailure {
  const CancelledFailure(super.message);
}
