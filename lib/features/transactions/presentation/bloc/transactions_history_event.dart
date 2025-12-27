import 'package:equatable/equatable.dart';

import '../../domain/entities/transactions_filter.dart';

abstract class TransactionsHistoryEvent extends Equatable {}

class LoadTransactionsHistoryEvent extends TransactionsHistoryEvent {
  @override
  List<Object?> get props => [];
}

class RefreshHistoryEvent extends TransactionsHistoryEvent {
  @override
  List<Object?> get props => [];
}

class SearchQueryHistoryEvent extends TransactionsHistoryEvent {
  final String query;

  SearchQueryHistoryEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class UpdateFiltersEvent extends TransactionsHistoryEvent {
  final TransactionFilter filter;

  UpdateFiltersEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}
