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

      final List<Map<String, dynamic>> maps = await db.query(
        'transactions',
        orderBy: 'date DESC',
      );

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
  Future<void> deleteAllTransactions(String userId) async {
    try {
      final db = await dbHelper.database;

      await db
          .delete('transactions', where: 'user_id = ?', whereArgs: [userId]);
    } catch (e) {
      throw CacheException('Failed to delete all transactions from db');
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

      // type_id: 1 = income, 2 = expense
      final incomeResult = await db.rawQuery(
        'SELECT SUM(amount_cents) as totalIncome FROM transactions WHERE type_id = ?',
        [1],
      );
      final expenseResult = await db.rawQuery(
        'SELECT SUM(amount_cents) as totalExpense FROM transactions WHERE type_id = ?',
        [2],
      );

      final totalIncome = (incomeResult.first['totalIncome'] as int?) ?? 0;
      final totalExpense = (expenseResult.first['totalExpense'] as int?) ?? 0;

      // Return as double (converting from cents)
      return (totalIncome - totalExpense) / 100.0;
    } catch (e) {
      throw CacheException('Failed to calculate total balance from db');
    }
  }

  @override
  Future<double> getTotalIncome() async {
    try {
      final db = await dbHelper.database;

      final incomeResult = await db.rawQuery(
        'SELECT SUM(amount_cents) as totalIncome FROM transactions WHERE type_id = ?',
        [1],
      );

      final totalIncome = (incomeResult.first['totalIncome'] as int?) ?? 0;
      return totalIncome / 100.0;
    } catch (e) {
      throw CacheException('Failed to calculate total income from db');
    }
  }

  @override
  Future<double> getTotalExpense() async {
    try {
      final db = await dbHelper.database;

      final expenseResult = await db.rawQuery(
        'SELECT SUM(amount_cents) as totalExpense FROM transactions WHERE type_id = ?',
        [2],
      );

      final totalExpense = (expenseResult.first['totalExpense'] as int?) ?? 0;
      return totalExpense / 100.0;
    } catch (e) {
      throw CacheException('Failed to calculate total expense from db');
    }
  }

  @override
  Future<double> getCurrentMonthExpense(int initialDay) async {
    try {
      final db = await dbHelper.database;
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, initialDay);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, initialDay - 1);

      final expenseResult = await db.rawQuery(
        'SELECT SUM(amount_cents) as monthlyExpense FROM transactions WHERE type_id = ? AND date BETWEEN ? AND ?',
        [
          2,
          firstDayOfMonth.toIso8601String(),
          lastDayOfMonth.toIso8601String(),
        ],
      );

      final monthlyExpense =
          (expenseResult.first['monthlyExpense'] as int?) ?? 0;
      return monthlyExpense / 100.0;
    } catch (e) {
      throw CacheException(
          'Failed to calculate current month expenses from db');
    }
  }

  @override
  Future<double> getMonthlySavings(int initialDay) async {
    try {
      final db = await dbHelper.database;
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, initialDay);
      final lastDayOfMonth = DateTime(now.year, now.month + 1, initialDay - 1);

      final incomeResult = await db.rawQuery(
        'SELECT SUM(amount_cents) as monthlyIncome FROM transactions WHERE type_id = ? AND date BETWEEN ? AND ?',
        [
          1,
          firstDayOfMonth.toIso8601String(),
          lastDayOfMonth.toIso8601String(),
        ],
      );

      final expenseResult = await db.rawQuery(
        'SELECT SUM(amount_cents) as monthlyExpense FROM transactions WHERE type_id = ? AND date BETWEEN ? AND ?',
        [
          2,
          firstDayOfMonth.toIso8601String(),
          lastDayOfMonth.toIso8601String(),
        ],
      );

      final monthlyIncome = (incomeResult.first['monthlyIncome'] as int?) ?? 0;
      final monthlyExpense =
          (expenseResult.first['monthlyExpense'] as int?) ?? 0;

      return (monthlyIncome - monthlyExpense) / 100.0;
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
        'SELECT SUM(amount_cents) as dailyExpense FROM transactions WHERE type_id = ? AND date BETWEEN ? AND ?',
        [
          2,
          startOfDay.toIso8601String(),
          endOfDay.toIso8601String(),
        ],
      );

      final dailyExpense = (expenseResult.first['dailyExpense'] as int?) ?? 0;
      return dailyExpense / 100.0;
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
      final startOfWeekDate =
          DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final expenseResult = await db.rawQuery(
        'SELECT SUM(amount_cents) as weeklyExpense FROM transactions WHERE type_id = ? AND date BETWEEN ? AND ?',
        [
          2,
          startOfWeekDate.toIso8601String(),
          endOfDay.toIso8601String(),
        ],
      );

      final weeklyExpense = (expenseResult.first['weeklyExpense'] as int?) ?? 0;
      return weeklyExpense / 100.0;
    } catch (e) {
      throw CacheException('Failed to calculate weekly expenses from db');
    }
  }
}
