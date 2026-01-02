import 'dart:async';

import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/exceptions.dart';
import 'package:eco_wallet/core/errors/base_failure.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/base_wallet_repository.dart';
import '../datasources/base_wallet_local_data_source.dart';
import '../models/transaction_model.dart';

class WalletRepositoryImpl implements BaseWalletRepository {
  final BaseWalletLocalDataSource dataSource;

  final _changeController = StreamController<void>.broadcast();

  WalletRepositoryImpl({required this.dataSource});

  @override
  Stream<void> get onTransactionsChanged => _changeController.stream;

  @override
  Future<Either<BaseFailure, Transaction>> addTransaction(Transaction transaction) async {
    try {
      final transactionModel = TransactionModel.fromEntity(transaction);

      await dataSource.cacheTransaction(transactionModel);
      _changeController.add(null); // Notify listeners of the change
      return Right(transactionModel);
    } on CacheException {
      return Left(CacheFailure('Failed to add transaction to local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<BaseFailure, Unit>> deleteTransaction(String transactionId) async {
    try {
      await dataSource.deleteTransaction(transactionId);
      _changeController.add(null); // Notify listeners of the change
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure('Failed to delete transaction from local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<BaseFailure, Transaction>> getTransactionById(String transactionId) async {
    try {
      final transactionModel = await dataSource.getTransactionById(transactionId);
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
      final transactionModels = await dataSource.getLastTransactions();
      return Right(transactionModels);
    } on CacheException {
      return Left(CacheFailure('Failed to get transactions from local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<BaseFailure, Transaction>> updateTransaction(Transaction transaction) async {
    try {
      final transactionModel = TransactionModel.fromEntity(transaction);
      await dataSource.cacheTransaction(transactionModel);
      _changeController.add(null); // Notify listeners of the change
      return Right(transactionModel);
    } on CacheException {
      return Left(CacheFailure('Failed to update transaction in local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<BaseFailure, double>> getCurrentMonthExpense() async {
    try {
      final totalExpense = await dataSource.getCurrentMonthExpense();
      return Right(totalExpense);
    } on CacheException {
      return Left(CacheFailure('Failed to get current month expense from local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<BaseFailure, double>> getTotalIncome() async {
    try {
      final totalIncome = await dataSource.getTotalIncome();
      return Right(totalIncome);
    } on CacheException {
      return Left(CacheFailure('Failed to get total income from local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<BaseFailure, double>> getTotalBalance() async {
    try {
      final totalBalance = await dataSource.getTotalBalance();
      return Right(totalBalance);
    } on CacheException {
      return Left(CacheFailure('Failed to get total balance from local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<BaseFailure, double>> getTotalExpense() async {
    try {
      final totalExpense = await dataSource.getTotalExpense();
      return Right(totalExpense);
    } on CacheException {
      return Left(CacheFailure('Failed to get total expense from local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<BaseFailure, double>> getMonthlySavings() async {
    try {
      final monthlySavings = await dataSource.getMonthlySavings();
      return Right(monthlySavings);
    } on CacheException {
      return Left(CacheFailure('Failed to get monthly savings from local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }
}
