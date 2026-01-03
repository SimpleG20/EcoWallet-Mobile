import 'package:eco_wallet/features/wallet/data/models/transaction_model.dart';
import 'package:eco_wallet/core/errors/exceptions.dart';

abstract class BaseWalletLocalDataSource {
  /// Gets the cached list of transactions.
  ///
  /// Throws a [CacheException] if no data is present or storage fails.
  Future<List<TransactionModel>> getLastTransactions();

  /// Saves a transaction to local storage.
  ///
  /// Uses upsert behavior: if a transaction with the same ID already exists,
  /// it will be replaced with the new transaction data. This allows both
  /// add and update operations to use the same method.
  ///
  /// Throws a [CacheException] if the save operation fails.
  Future<void> cacheTransaction(TransactionModel transaction);

  /// Deletes a transaction from local storage by its ID.
  ///
  /// Throws a [CacheException] if the delete operation fails.
  Future<void> deleteTransaction(String transactionId);

  /// Retrieves a transaction by its ID from local storage.
  ///
  /// Throws a [CacheException] if the retrieval operation fails.
  Future<TransactionModel> getTransactionById(String transactionId);

  /// Calculates the total expenses for the current month.
  ///
  /// Throws a [CacheException] if the calculation fails.
  Future<double> getCurrentMonthExpense();

  /// Calculates the total income for the current month.
  ///
  /// Throws a [CacheException] if the calculation fails.
  Future<double> getTotalIncome();

  /// Calculates the total balance from all transactions.
  ///
  /// Throws a [CacheException] if the calculation fails.
  Future<double> getTotalBalance();

  /// Calculates the total expenses from all transactions.
  ///
  /// Throws a [CacheException] if the calculation fails.
  Future<double> getTotalExpense();

  /// Calculates the monthly savings based on income and expenses.
  ///
  /// Throws a [CacheException] if the calculation fails.
  Future<double> getMonthlySavings();

  /// Calculates the total expenses for the current day.
  ///
  /// Throws a [CacheException] if the calculation fails.
  Future<double> getDailyExpense();

  /// Calculates the total expenses for the current week.
  ///
  /// Throws a [CacheException] if the calculation fails.
  Future<double> getWeeklyExpense();
}
