import 'package:fpdart/fpdart.dart';
import 'package:ecowallet/core/error/failures.dart';
import 'package:ecowallet/domain/entities/transaction.dart';
import 'package:ecowallet/domain/repositories/transaction_repository.dart';
import 'package:ecowallet/data/datasources/database/database.dart';
import 'package:ecowallet/data/models/transaction_model.dart';

/// Implementation of TransactionRepository using Drift database
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Future<Either<Failure, Transaction>> addTransaction(
    Transaction transaction,
  ) async {
    try {
      await _database.insertTransaction(transaction.toCompanion());
      return Right(transaction);
    } catch (e) {
      return Left(DatabaseFailure('Failed to add transaction: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransaction(String id) async {
    try {
      final result = await _database.getTransactionById(id);
      if (result == null) {
        return const Left(DatabaseFailure('Transaction not found'));
      }
      return Right(result.toDomain());
    } catch (e) {
      return Left(
        DatabaseFailure('Failed to get transaction: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getAllTransactions() async {
    try {
      final results = await _database.getAllTransactions();
      final transactions = results.map((t) => t.toDomain()).toList();
      return Right(transactions);
    } catch (e) {
      return Left(
        DatabaseFailure('Failed to get all transactions: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final results = await _database.getTransactionsByDateRange(
        start: startDate,
        end: endDate,
      );
      final transactions = results.map((t) => t.toDomain()).toList();
      return Right(transactions);
    } catch (e) {
      return Left(
        DatabaseFailure(
          'Failed to get transactions by date range: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByType(
    TransactionType type,
  ) async {
    try {
      final typeString = type == TransactionType.income ? 'income' : 'expense';
      final results = await _database.getTransactionsByType(typeString);
      final transactions = results.map((t) => t.toDomain()).toList();
      return Right(transactions);
    } catch (e) {
      return Left(
        DatabaseFailure('Failed to get transactions by type: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(
    String category,
  ) async {
    try {
      final results = await _database.getTransactionsByCategory(category);
      final transactions = results.map((t) => t.toDomain()).toList();
      return Right(transactions);
    } catch (e) {
      return Left(
        DatabaseFailure(
          'Failed to get transactions by category: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Transaction>> updateTransaction(
    Transaction transaction,
  ) async {
    try {
      // Check if transaction exists before updating
      final existing = await _database.getTransactionById(transaction.id);
      if (existing == null) {
        return const Left(
          DatabaseFailure('Transaction not found - cannot update'),
        );
      }
      
      final success = await _database.updateTransaction(transaction.toDrift());
      if (!success) {
        return const Left(DatabaseFailure('Failed to update transaction'));
      }
      return Right(transaction);
    } catch (e) {
      return Left(
        DatabaseFailure('Failed to update transaction: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTransaction(String id) async {
    try {
      await _database.deleteTransaction(id);
      return const Right(unit);
    } catch (e) {
      return Left(
        DatabaseFailure('Failed to delete transaction: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, double>> getTotalIncome() async {
    try {
      final total = await _database.getTotalIncome();
      return Right(total);
    } catch (e) {
      return Left(
        DatabaseFailure('Failed to get total income: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, double>> getTotalExpense() async {
    try {
      final total = await _database.getTotalExpense();
      return Right(total);
    } catch (e) {
      return Left(
        DatabaseFailure('Failed to get total expense: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, double>> getBalance() async {
    try {
      final income = await _database.getTotalIncome();
      final expense = await _database.getTotalExpense();
      return Right(income - expense);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get balance: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> getTransactionsCount() async {
    try {
      final count = await _database.getTransactionsCount();
      return Right(count);
    } catch (e) {
      return Left(
        DatabaseFailure('Failed to get transactions count: ${e.toString()}'),
      );
    }
  }
}
