import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/wallet/domain/repositories/base_wallet_repository.dart';
import 'package:fpdart/fpdart.dart';

/// Use case to get total expenses for the current month.
class GetMonthlyExpense implements BaseUsecase<double, int> {
  final BaseWalletRepository repository;

  GetMonthlyExpense(this.repository);

  @override
  Future<Either<BaseFailure, double>> call(int initialDay) {
    return repository.getCurrentMonthExpense(initialDay);
  }
}
