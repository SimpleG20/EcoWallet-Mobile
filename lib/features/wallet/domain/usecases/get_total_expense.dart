import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/wallet/domain/repositories/base_wallet_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetTotalExpense implements BaseUsecase<double, NoParams> {
  final BaseWalletRepository repository;

  GetTotalExpense(this.repository);

  @override
  Future<Either<BaseFailure, double>> call(NoParams params) {
    return repository.getTotalExpense();
  }
}
