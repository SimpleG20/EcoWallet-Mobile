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

      final List<Map<String, dynamic>> maps = await db.query('transactions', orderBy: 'date DESC');

      if (maps.isEmpty) {
        return [];
      }

      return maps.map((e) => TransactionModel.fromJson(e)).toList();
    } catch (e) {
      throw CacheException('Failed to load last transactions from db');
    }
  }

  @override
  Future<void> cacheTransaction(TransactionModel transaction) async {
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
    } on CacheException {
      rethrow;
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
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to get transaction from db');
    }
  }

  @override
  Future<double> getTotalBalance() async {
    try {
      final db = await dbHelper.database;

      final incomeResult =
          await db.rawQuery('SELECT SUM(amount) as totalIncome FROM transactions WHERE type = ?', ['income']);
      final expenseResult =
          await db.rawQuery('SELECT SUM(amount) as totalExpense FROM transactions WHERE type = ?', ['expense']);

      final totalIncome = incomeResult.first['totalIncome'] as double? ?? 0.0;
      final totalExpense = expenseResult.first['totalExpense'] as double? ?? 0.0;

      return totalIncome - totalExpense;
    } catch (e) {
      throw CacheException('Failed to calculate total balance from db');
    }
  }

  @override
  Future<double> getTotalIncome() async {
    try {
      final db = await dbHelper.database;

      final incomeResult =
          await db.rawQuery('SELECT SUM(amount) as totalIncome FROM transactions WHERE type = ?', ['income']);

      return incomeResult.first['totalIncome'] as double? ?? 0.0;
    } catch (e) {
      throw CacheException('Failed to calculate total income from db');
    }
  }

  @override
  Future<double> getTotalExpense() async {
    try {
      final db = await dbHelper.database;
      final expenseResult =
          await db.rawQuery('SELECT SUM(amount) as totalExpense FROM transactions WHERE type = ?', ['expense']);
      return expenseResult.first['totalExpense'] as double? ?? 0.0;
    } catch (e) {
      throw CacheException('Failed to calculate total expense from db');
    }
  }

  @override
  Future<double> getCurrentMonthExpense() async {
    try {
      final db = await dbHelper.database;
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      final expenseResult = await db.rawQuery(
        'SELECT SUM(amount) as monthlyExpense FROM transactions WHERE type = ? AND date BETWEEN ? AND ?',
        [
          'expense',
          firstDayOfMonth.toIso8601String(),
          lastDayOfMonth.toIso8601String(),
        ],
      );

      return expenseResult.first['monthlyExpense'] as double? ?? 0.0;
    } catch (e) {
      throw CacheException('Failed to calculate current month expenses from db');
    }
  }

  @override
  Future<double> getMonthlySavings() async {
    try {
      final db = await dbHelper.database;
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      final incomeResult = await db.rawQuery(
        'SELECT SUM(amount) as monthlyIncome FROM transactions WHERE type = ? AND date BETWEEN ? AND ?',
        [
          'income',
          firstDayOfMonth.toIso8601String(),
          lastDayOfMonth.toIso8601String(),
        ],
      );

      final expenseResult = await db.rawQuery(
        'SELECT SUM(amount) as monthlyExpense FROM transactions WHERE type = ? AND date BETWEEN ? AND ?',
        [
          'expense',
          firstDayOfMonth.toIso8601String(),
          lastDayOfMonth.toIso8601String(),
        ],
      );

      final monthlyIncome = incomeResult.first['monthlyIncome'] as double? ?? 0.0;
      final monthlyExpense = expenseResult.first['monthlyExpense'] as double? ?? 0.0;

      return monthlyIncome - monthlyExpense;
    } catch (e) {
      throw CacheException('Failed to calculate monthly savings from db');
    }
  }

  @override
  Future<double> getDailyExpense() async {
    try {
      final db = await dbHelper.database;
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final expenseResult = await db.rawQuery(
        'SELECT SUM(amount) as dailyExpense FROM transactions WHERE type = ? AND date BETWEEN ? AND ?',
        [
          'expense',
          startOfDay.toIso8601String(),
          endOfDay.toIso8601String(),
        ],
      );

      return expenseResult.first['dailyExpense'] as double? ?? 0.0;
    } catch (e) {
      throw CacheException('Failed to calculate daily expenses from db');
    }
  }

  @override
  Future<double> getWeeklyExpense() async {
    try {
      final db = await dbHelper.database;
      final now = DateTime.now();
      // Get start of the week (Monday)
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeekDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final expenseResult = await db.rawQuery(
        'SELECT SUM(amount) as weeklyExpense FROM transactions WHERE type = ? AND date BETWEEN ? AND ?',
        [
          'expense',
          startOfWeekDate.toIso8601String(),
          endOfDay.toIso8601String(),
        ],
      );

      return expenseResult.first['weeklyExpense'] as double? ?? 0.0;
    } catch (e) {
      throw CacheException('Failed to calculate weekly expenses from db');
    }
  }
}

