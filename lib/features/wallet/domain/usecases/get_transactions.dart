import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';

import '../entities/transaction.dart';
import '../repositories/base_wallet_repository.dart';

class GetTransactions implements BaseUsecase<List<Transaction>, NoParams> {
  final BaseWalletRepository repository;

  GetTransactions(this.repository);

  @override
  Future<Either<BaseFailure, List<Transaction>>> call(NoParams params) {
    return repository.getTransactions();
  }
}
