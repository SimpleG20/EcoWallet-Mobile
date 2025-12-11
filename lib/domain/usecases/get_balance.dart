import 'package:fpdart/fpdart.dart';
import 'package:ecowallet/core/error/failures.dart';
import 'package:ecowallet/core/usecase/usecase.dart';
import 'package:ecowallet/domain/repositories/transaction_repository.dart';

/// Use case for getting current balance
class GetBalance implements UseCase<double, NoParams> {
  GetBalance(this.repository);

  final TransactionRepository repository;

  @override
  Future<Either<Failure, double>> call(NoParams params) =>
      repository.getBalance();
}
