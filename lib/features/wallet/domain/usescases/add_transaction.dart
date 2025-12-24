import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usescases/base_usecase.dart';
import 'package:eco_wallet/features/wallet/domain/repositories/base_wallet_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/transaction.dart';

class AddTransaction implements BaseUsecase<Unit, Transaction> {
  final BaseWalletRepository repository;

  AddTransaction(this.repository);

  @override
  Future<Either<BaseFailure, Unit>> call(Transaction transaction) async {
    final result = await repository.addTransaction(transaction);
    return result.fold(
      (failure) => Left(failure),
      (createdTransaction) => Right(unit),
    );
  }
}
