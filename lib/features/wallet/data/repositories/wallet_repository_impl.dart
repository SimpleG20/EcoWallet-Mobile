import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/exceptions.dart';
import 'package:eco_wallet/core/errors/base_failure.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/base_wallet_repository.dart';
import '../datasources/base_wallet_local_data_source.dart';
import '../models/transaction_model.dart';

class WalletRepositoryImpl implements BaseWalletRepository {
  final BaseWalletLocalDataSource localDataSource;

  WalletRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<BaseFailure, Transaction>> addTransaction(
      Transaction transaction) async {
    try {
      final transactionModel = TransactionModel.fromEntity(transaction);

      await localDataSource.cacheTransaction(transactionModel);

      return Right(transactionModel);
    } on CacheException {
      return Left(CacheFailure('Failed to add transaction to local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<BaseFailure, Unit>> deleteTransaction(
      String transactionId) async {
    try {
      await localDataSource.deleteTransaction(transactionId);
      return const Right(unit);
    } on CacheException {
      return Left(
          CacheFailure('Failed to delete transaction from local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<BaseFailure, Transaction>> getTransactionById(
      String transactionId) async {
    try {
      final transactionModel =
          await localDataSource.getTransactionById(transactionId);
      return Right(transactionModel);
    } on CacheException {
      return Left(CacheFailure('Failed to get transaction from local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<BaseFailure, List<Transaction>>> getTransactions() async {
    try {
      final transactionModels = await localDataSource.getLastTransactions();
      return Right(transactionModels);
    } on CacheException {
      return Left(
          CacheFailure('Failed to get transactions from local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<BaseFailure, Transaction>> updateTransaction(
      Transaction transaction) async {
    try {
      final transactionModel = TransactionModel.fromEntity(transaction);
      await localDataSource.cacheTransaction(transactionModel);
      return Right(transactionModel);
    } on CacheException {
      return Left(
          CacheFailure('Failed to update transaction in local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }
}
