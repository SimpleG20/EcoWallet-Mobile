import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/usescases/base_usecase.dart';
import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';

import '../repositories/base_wallet_repository.dart';

class UpdateTransaction implements BaseUsecase<Unit, Transaction> {
  final BaseWalletRepository repository;

  UpdateTransaction(this.repository);

  @override
  Future<Either<BaseFailure, Unit>> call(Transaction transaction) async {
    final result = await repository.updateTransaction(transaction);
    return result.map((_) => unit);
  }
}
