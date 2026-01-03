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
  Future<Either<BaseFailure, double>> getCurrentMonthExpense(int initialDay) async {
    try {
      final totalExpense = await dataSource.getCurrentMonthExpense(initialDay);
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
  Future<Either<BaseFailure, double>> getMonthlySavings(int initialDay) async {
    try {
      final monthlySavings = await dataSource.getMonthlySavings(initialDay);
      return Right(monthlySavings);
    } on CacheException {
      return Left(CacheFailure('Failed to get monthly savings from local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<BaseFailure, double>> getDailyExpense() async {
    try {
      final dailyExpense = await dataSource.getDailyExpense();
      return Right(dailyExpense);
    } on CacheException {
      return Left(CacheFailure('Failed to get daily expense from local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }

  @override
  Future<Either<BaseFailure, double>> getWeeklyExpense() async {
    try {
      final weeklyExpense = await dataSource.getWeeklyExpense();
      return Right(weeklyExpense);
    } on CacheException {
      return Left(CacheFailure('Failed to get weekly expense from local storage'));
    } catch (e) {
      return Left(UnknownFailure('An unknown error occurred: $e'));
    }
  }
}
