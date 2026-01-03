import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/wallet/domain/repositories/base_wallet_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteAllTransactions implements BaseUsecase<Unit, String> {
  final BaseWalletRepository repository;

  DeleteAllTransactions(this.repository);

  @override
  Future<Either<BaseFailure, Unit>> call(String userId) {
    return repository.deleteAllTransactions(userId);
  }
}
