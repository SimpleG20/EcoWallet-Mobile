import 'package:fpdart/fpdart.dart';
import 'package:ecowallet/core/error/failures.dart';
import 'package:ecowallet/core/usecase/usecase.dart';
import 'package:ecowallet/domain/entities/transaction.dart';
import 'package:ecowallet/domain/repositories/transaction_repository.dart';

/// Use case for getting all transactions
class GetAllTransactions
    implements UseCase<List<Transaction>, NoParams> {
  GetAllTransactions(this.repository);

  final TransactionRepository repository;

  @override
  Future<Either<Failure, List<Transaction>>> call(NoParams params) =>
      repository.getAllTransactions();
}
