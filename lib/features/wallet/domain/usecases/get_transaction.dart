import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';

import '../entities/transaction.dart';
import '../repositories/base_wallet_repository.dart';

class GetTransaction implements BaseUsecase<Transaction, String> {
  final BaseWalletRepository repository;

  GetTransaction(this.repository);

  @override
  Future<Either<BaseFailure, Transaction>> call(String transactionId) async {
    return await repository.getTransactionById(transactionId);
  }
}
