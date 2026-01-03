import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';

abstract class BaseWalletRepository {
  Future<Either<BaseFailure, List<Transaction>>> getTransactions();
  Future<Either<BaseFailure, Transaction>> getTransactionById(String transactionId);

  /// Adds a new transaction to the repository.
  ///
  /// Note: Uses upsert behavior - if a transaction with the same ID exists,
  /// it will be replaced. To ensure a transaction doesn't already exist,
  /// the caller should generate a unique ID before calling this method.
  Future<Either<BaseFailure, Transaction>> addTransaction(Transaction transaction);

  /// Updates an existing transaction in the repository.
  ///
  /// Note: Uses upsert behavior - if the transaction doesn't exist,
  /// it will be created. This allows for a unified storage mechanism.
  Future<Either<BaseFailure, Transaction>> updateTransaction(Transaction transaction);

  Future<Either<BaseFailure, Unit>> deleteTransaction(String transactionId);

  Future<Either<BaseFailure, double>> getTotalIncome();
  Future<Either<BaseFailure, double>> getTotalBalance();
  Future<Either<BaseFailure, double>> getTotalExpense();
  Future<Either<BaseFailure, double>> getDailyExpense();
  Future<Either<BaseFailure, double>> getWeeklyExpense();

  Future<Either<BaseFailure, double>> getMonthlySavings(int initialDay);
  Future<Either<BaseFailure, double>> getCurrentMonthExpense(int initialDay);

  Stream<void> get onTransactionsChanged;
}
