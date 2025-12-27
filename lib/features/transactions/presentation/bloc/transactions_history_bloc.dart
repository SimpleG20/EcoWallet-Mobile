import 'dart:async';

import 'package:eco_wallet/features/wallet/domain/repositories/base_wallet_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'transactions_history_event.dart';
import 'transactions_history_state.dart';
import '/core/usecases/base_usecase.dart';
import '../../domain/entities/transactions_filter.dart';
import '../../domain/usecases/filter_transactions.dart';
import '../../domain/usecases/search_query_transactions.dart';
import '../../../wallet/domain/entities/transaction.dart';
import '../../../wallet/domain/usecases/get_transactions.dart';

class TransactionsHistoryBloc
    extends Bloc<TransactionsHistoryEvent, BaseTransactionsHistoryState> {
  final GetTransactions getTransactions;
  final FilterTransactions filterTransactions;
  final SearchQueryTransactions searchTransactions;
  final BaseWalletRepository repository;

  StreamSubscription? _transactionsSubscription;

  TransactionsHistoryBloc({
    required this.getTransactions,
    required this.filterTransactions,
    required this.searchTransactions,
    required this.repository,
  }) : super(TransactionsHistoryInitial()) {
    on<LoadTransactionsHistoryEvent>(_onLoadHistory);
    on<RefreshHistoryEvent>(_onRefreshHistory);
    on<SearchQueryHistoryEvent>(_onSearchQuery);
    on<UpdateFiltersEvent>(_onUpdateFilters);

    _transactionsSubscription = repository.onTransactionsChanged.listen((_) {
      add(RefreshHistoryEvent());
    });
  }

  @override
  Future<void> close() {
    _transactionsSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadHistory(LoadTransactionsHistoryEvent event,
      Emitter<BaseTransactionsHistoryState> emit) async {
    emit(TransactionsHistoryLoading());
    final result = await getTransactions(NoParams());

    result.fold(
      (failure) => emit(
          const TransactionsHistoryError("Erro ao carregar as transacoes")),
      (data) => emit(
        TransactionsHistoryLoaded(
          allTransactions: data,
          visibleTransactions: data,
          filter: TransactionFilter.empty(),
        ),
      ),
    );
  }

  Future<void> _onRefreshHistory(RefreshHistoryEvent event,
      Emitter<BaseTransactionsHistoryState> emit) async {
    final currentState = state;
    var activeFilter = const TransactionFilter(); // Default vazio
    var searchQuery = '';

    if (currentState is TransactionsHistoryLoaded) {
      activeFilter = currentState.filter;
      searchQuery = currentState.searchQuery;
    }

    final result = await getTransactions(NoParams());

    result.fold(
      (failure) {
        emit(const TransactionsHistoryError("Não foi possível atualizar"));
      },
      (freshData) {
        final visible = _applyAllLogic(freshData, activeFilter, searchQuery);

        emit(TransactionsHistoryLoaded(
          allTransactions: freshData,
          visibleTransactions: visible,
          filter: activeFilter,
          searchQuery: searchQuery,
        ));
      },
    );
  }

  void _onSearchQuery(SearchQueryHistoryEvent event,
      Emitter<BaseTransactionsHistoryState> emit) {
    final currentState = state;
    if (currentState is! TransactionsHistoryLoaded) return;

    final newQuery = event.query;

    final visible = _applyAllLogic(
        currentState.allTransactions, currentState.filter, newQuery);

    emit(currentState.copyWith(
      searchQuery: newQuery,
      visibleTransactions: visible,
    ));
  }

  Future<void> _onUpdateFilters(UpdateFiltersEvent event,
      Emitter<BaseTransactionsHistoryState> emit) async {
    final currentState = state;
    if (currentState is! TransactionsHistoryLoaded) return;

    final newFilter = event.filter;

    final visible = _applyAllLogic(
        currentState.allTransactions, newFilter, currentState.searchQuery);

    emit(currentState.copyWith(
      filterType: newFilter,
      visibleTransactions: visible,
    ));
  }

  List<Transaction> _applyAllLogic(
      List<Transaction> all, TransactionFilter filter, String query) {
    return all.where((t) {
      final matchQuery =
          query.isEmpty || t.name.toLowerCase().contains(query.toLowerCase());

      if (!matchQuery) return false;

      return filter.apply(t);
    }).toList();
  }
}
