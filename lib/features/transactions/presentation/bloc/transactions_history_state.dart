import 'package:eco_wallet/features/transactions/domain/entities/transactions_filter.dart';
import 'package:equatable/equatable.dart';

import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';

abstract class BaseTransactionsHistoryState extends Equatable {
  const BaseTransactionsHistoryState();

  @override
  List<Object?> get props => [];
}

class TransactionsHistoryInitial extends BaseTransactionsHistoryState {}

class TransactionsHistoryLoading extends BaseTransactionsHistoryState {}

class TransactionsHistoryError extends BaseTransactionsHistoryState {
  final String message;

  const TransactionsHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class TransactionsHistoryLoaded extends BaseTransactionsHistoryState {
  final List<Transaction> allTransactions;
  final List<Transaction> visibleTransactions;
  final TransactionFilter filter;
  final String searchQuery;

  const TransactionsHistoryLoaded({
    required this.allTransactions,
    required this.visibleTransactions,
    required this.filter,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
        visibleTransactions,
        filter,
        searchQuery,
      ];

  factory TransactionsHistoryLoaded.initial() {
    return TransactionsHistoryLoaded(
      allTransactions: const [],
      visibleTransactions: const [],
      filter: TransactionFilter.empty(),
      searchQuery: '',
    );
  }

  TransactionsHistoryLoaded copyWith({
    List<Transaction>? allTransactions,
    List<Transaction>? visibleTransactions,
    TransactionFilter? filterType,
    String? searchQuery,
  }) {
    return TransactionsHistoryLoaded(
      allTransactions: allTransactions ?? this.allTransactions,
      visibleTransactions: visibleTransactions ?? this.visibleTransactions,
      filter: filterType ?? filter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
