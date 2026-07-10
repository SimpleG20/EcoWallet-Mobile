import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:fpdart/fpdart.dart';

import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';

class SearchQueryTransactions
    extends BaseUsecase<List<Transaction>, SearchQueryParams> {
  @override
  Future<Either<BaseFailure, List<Transaction>>> call(
      SearchQueryParams params) async {
    var query = params.query.toLowerCase();
    List<Transaction> filteredTransactions = params.allTransactions
        .where((transaction) =>
            transaction.name.toLowerCase().contains(query) ||
            transaction.amount.toString().contains(query) ||
            transaction.date.toString().contains(query))
        .toList();

    return Right(filteredTransactions);
  }
}

class SearchQueryParams {
  final String query;
  final List<Transaction> allTransactions;

  SearchQueryParams({required this.query, required this.allTransactions});
}
