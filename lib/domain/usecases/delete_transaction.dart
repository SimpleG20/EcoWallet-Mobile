import 'package:fpdart/fpdart.dart';
import 'package:ecowallet/core/error/failures.dart';
import 'package:ecowallet/core/usecase/usecase.dart';
import 'package:ecowallet/domain/repositories/transaction_repository.dart';

/// Use case for deleting a transaction
class DeleteTransaction implements UseCase<Unit, DeleteTransactionParams> {
  DeleteTransaction(this.repository);

  final TransactionRepository repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteTransactionParams params) =>
      repository.deleteTransaction(params.id);
}

/// Parameters for DeleteTransaction use case
class DeleteTransactionParams {
  const DeleteTransactionParams({required this.id});

  final String id;
}
