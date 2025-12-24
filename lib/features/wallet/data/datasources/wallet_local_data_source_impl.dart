import 'package:eco_wallet/core/database/db_helper.dart';
import 'package:eco_wallet/core/errors/exceptions.dart';
import 'package:sqflite/sqflite.dart';

import '../models/transaction_model.dart';
import 'base_wallet_local_data_source.dart';

class WalletLocalDataSourceImpl implements BaseWalletLocalDataSource {
  final DbHelper dbHelper;
  WalletLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<List<TransactionModel>> getLastTransactions() async {
    try {
      final db = await dbHelper.database;

      final List<Map<String, dynamic>> maps =
          await db.query('transactions', orderBy: 'date DESC');

      if (maps.isEmpty) {
        return [];
      }

      return maps.map((e) => TransactionModel.fromJson(e)).toList();
    } catch (e) {
      throw CacheException('Failed to load last transactions from db');
    }
  }

  @override
  Future<void> cacheTransactions(TransactionModel transaction) async {
    try {
      final db = await dbHelper.database;

      await db.insert(
        'transactions',
        transaction.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Failed to cache transaction to db');
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    try {
      final db = await dbHelper.database;

      final count = await db.delete(
        'transactions',
        where: 'id = ?',
        whereArgs: [transactionId],
      );

      if (count == 0) {
        throw CacheException('Transaction not found for deletion');
      }
    } catch (e) {
      throw CacheException('Failed to delete transaction from db');
    }
  }

  @override
  Future<TransactionModel> getTransactionById(String transactionId) async {
    try {
      final db = await dbHelper.database;

      final List<Map<String, dynamic>> maps = await db.query(
        'transactions',
        where: 'id = ?',
        whereArgs: [transactionId],
      );

      if (maps.isEmpty) {
        throw CacheException('Transaction not found');
      }

      return TransactionModel.fromJson(maps.first);
    } catch (e) {
      throw CacheException('Failed to get transaction from db');
    }
  }
}
