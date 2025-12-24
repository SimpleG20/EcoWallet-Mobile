import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';

abstract class BaseWalletRepository {
  Future<Either<BaseFailure, List<Transaction>>> getTransactions();
  Future<Either<BaseFailure, Transaction>> getTransactionById(
      String transactionId);
  Future<Either<BaseFailure, Transaction>> addTransaction(
      Transaction transaction);
  Future<Either<BaseFailure, Transaction>> updateTransaction(
      Transaction transaction);
  Future<Either<BaseFailure, Unit>> deleteTransaction(String transactionId);
}
