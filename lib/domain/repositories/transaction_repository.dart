import 'package:fpdart/fpdart.dart';
import 'package:ecowallet/core/error/failures.dart';
import 'package:ecowallet/domain/entities/transaction.dart';

/// Repository interface for transaction operations
abstract class TransactionRepository {
  /// Add a new transaction
  Future<Either<Failure, Transaction>> addTransaction(Transaction transaction);

  /// Get a transaction by ID
  Future<Either<Failure, Transaction>> getTransaction(String id);

  /// Get all transactions
  Future<Either<Failure, List<Transaction>>> getAllTransactions();

  /// Get transactions by date range
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get transactions by type
  Future<Either<Failure, List<Transaction>>> getTransactionsByType(
    TransactionType type,
  );

  /// Get transactions by category
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(
    String category,
  );

  /// Update a transaction
  Future<Either<Failure, Transaction>> updateTransaction(
    Transaction transaction,
  );

  /// Delete a transaction
  Future<Either<Failure, Unit>> deleteTransaction(String id);

  /// Get total income
  Future<Either<Failure, double>> getTotalIncome();

  /// Get total expense
  Future<Either<Failure, double>> getTotalExpense();

  /// Get balance
  Future<Either<Failure, double>> getBalance();

  /// Get transactions count
  Future<Either<Failure, int>> getTransactionsCount();
}
