import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/wallet/domain/repositories/base_wallet_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetTotalBalance implements BaseUsecase<double, NoParams> {
  final BaseWalletRepository repository;

  GetTotalBalance(this.repository);

  @override
  Future<Either<BaseFailure, double>> call(NoParams params) {
    return repository.getTotalBalance();
  }
}
