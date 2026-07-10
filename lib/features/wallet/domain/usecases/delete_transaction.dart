import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';

import 'package:eco_wallet/features/wallet/domain/repositories/base_wallet_repository.dart';

class DeleteTransaction implements BaseUsecase<Unit, String> {
  final BaseWalletRepository repository;

  DeleteTransaction(this.repository);

  @override
  Future<Either<BaseFailure, Unit>> call(String transactionId) {
    return repository.deleteTransaction(transactionId);
  }
}
