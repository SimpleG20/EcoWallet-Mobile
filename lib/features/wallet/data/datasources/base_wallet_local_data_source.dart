import 'package:eco_wallet/features/wallet/data/models/transaction_model.dart';
import 'package:eco_wallet/core/errors/exceptions.dart';

abstract class BaseWalletLocalDataSource {
  /// Gets the cached list of transactions.
  ///
  /// Throws a [CacheException] if no data is present or storage fails.
  Future<List<TransactionModel>> getLastTransactions();

  /// Saves a transaction to local storage.
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
}
