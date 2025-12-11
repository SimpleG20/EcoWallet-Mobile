import 'package:fpdart/fpdart.dart';
import 'package:ecowallet/core/error/failures.dart';
import 'package:ecowallet/core/usecase/usecase.dart';
import 'package:ecowallet/domain/entities/transaction.dart';
import 'package:ecowallet/domain/repositories/transaction_repository.dart';

/// Use case for adding a new transaction
class AddTransaction implements UseCase<Transaction, AddTransactionParams> {
  AddTransaction(this.repository);

  final TransactionRepository repository;

  @override
  Future<Either<Failure, Transaction>> call(AddTransactionParams params) =>
      repository.addTransaction(params.transaction);
}

/// Parameters for AddTransaction use case
class AddTransactionParams {
  const AddTransactionParams({required this.transaction});

  final Transaction transaction;
}
