import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/get_transaction.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/update_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../../../core/usecases/base_usecase.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetTransaction getTransactionById;
  final GetTransactions getTransactions;
  final AddTransaction addTransaction;
  final DeleteTransaction deleteTransaction;
  final UpdateTransaction updateTransaction;

  WalletBloc({
    required this.getTransactions,
    required this.addTransaction,
    required this.deleteTransaction,
    required this.updateTransaction,
    required this.getTransactionById,
  }) : super(WalletInitial()) {
    on<LoadWalletDataEvent>(_onLoadWalletData);
    on<GetTransactionsEvent>(_onGetTransactions);
    on<AddTransactionEvent>(_onAddTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    on<UpdateTransactionEvent>(_onUpdateTransaction);
    on<GetTransactionEvent>(_onGetTransaction);
  }

  Future<void> _onLoadWalletData(
      LoadWalletDataEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());

    final result = await getTransactions(NoParams());

    result.fold(
      (failure) => emit(const WalletError("Erro ao carregar dados")),
      (transactions) {
        emit(
          WalletLoaded(
            transactions: transactions,
            totalBalance: _calculateTotalBalance(transactions),
            totalIncome: _calculateTotalIncome(transactions),
            totalExpense: _calculateTotalExpense(transactions),
            monthlySavings: _calculateMonthlySavings(transactions),
          ),
        );
      },
    );
  }

  Future<void> _onGetTransactions(
      GetTransactionsEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());

    final result = await getTransactions(NoParams());

    result.fold(
      (failure) => emit(const WalletError("Erro ao carregar dados")),
      (transactions) => emit(WalletTransactionsLoaded(transactions)),
    );
  }

  double _calculateTotalBalance(List<Transaction> transactions) {
    return transactions.fold(
        0.0,
        (previousValue, transaction) =>
            transaction.type == ETransactionType.income
                ? previousValue + transaction.amount
                : previousValue - transaction.amount);
  }

  double _calculateTotalIncome(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == ETransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calculateTotalExpense(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == ETransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _calculateMonthlySavings(List<Transaction> transactions) {
    var now = DateTime.now();
    var monthlyIncome = transactions
        .where((t) =>
            t.type == ETransactionType.income &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
    var monthlyExpense = transactions
        .where((t) =>
            t.type == ETransactionType.expense &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
    if (monthlyIncome > monthlyExpense) {
      return monthlyIncome - monthlyExpense;
    } else {
      return 0.0;
    }
  }

  Future<void> _onAddTransaction(
      AddTransactionEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());

    final result = await addTransaction(event.transaction);
    result.fold(
      (failure) => emit(const WalletError("Erro ao adicionar transação")),
      (_) => add(LoadWalletDataEvent()),
    );
  }

  Future<void> _onDeleteTransaction(
      DeleteTransactionEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());

    final result = await deleteTransaction(event.transactionId);
    result.fold(
        (failure) => emit(const WalletError("Erro ao deletar transação")),
        (_) => add(LoadWalletDataEvent()));
  }

  Future<void> _onUpdateTransaction(
      UpdateTransactionEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());

    final result = await updateTransaction(event.transaction);
    result.fold(
      (failure) => emit(const WalletError("Erro ao atualizar transação")),
      (_) => add(LoadWalletDataEvent()),
    );
  }

  Future<void> _onGetTransaction(
      GetTransactionEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());

    final result = await getTransactionById(event.transactionId);

    result.fold(
      (failure) => emit(const WalletError("Erro ao carregar dados")),
      (transaction) {
        emit(WalletTransactionLoaded(transaction));
      },
    );
  }
}
