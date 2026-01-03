import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/get_transaction.dart';
import '../../domain/usecases/get_total_income.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/get_total_expense.dart';
import '../../domain/usecases/get_total_balance.dart';
import '../../domain/usecases/update_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_monthly_savings.dart';
import '../../domain/usecases/get_daily_expense.dart';
import '../../domain/usecases/get_weekly_expense.dart';
import '../../domain/usecases/get_monthly_expense.dart';
import '../../domain/repositories/base_wallet_repository.dart';
import '../../../../core/usecases/base_usecase.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, BaseWalletState> {
  final GetTransaction getTransactionById;
  final GetTransactions getTransactions;
  final AddTransaction addTransaction;
  final DeleteTransaction deleteTransaction;
  final UpdateTransaction updateTransaction;
  final GetTotalBalance getTotalBalance;
  final GetTotalIncome getTotalIncome;
  final GetTotalExpense getTotalExpense;
  final GetMonthlySavings getMonthlySavings;
  final GetDailyExpense getDailyExpense;
  final GetWeeklyExpense getWeeklyExpense;
  final GetMonthlyExpense getMonthlyExpense;

  final BaseWalletRepository walletRepository;

  StreamSubscription? _transactionsSubscription;

  WalletBloc({
    required this.getTransactions,
    required this.addTransaction,
    required this.deleteTransaction,
    required this.updateTransaction,
    required this.getTransactionById,
    required this.getTotalBalance,
    required this.getTotalIncome,
    required this.getTotalExpense,
    required this.getMonthlySavings,
    required this.getDailyExpense,
    required this.getWeeklyExpense,
    required this.getMonthlyExpense,
    required this.walletRepository,
  }) : super(WalletInitial()) {
    on<LoadWalletDataEvent>(_onLoadWalletData);
    on<AddTransactionEvent>(_onAddTransaction);
    on<GetTransactionEvent>(_onGetTransaction);
    on<GetTransactionsEvent>(_onGetTransactions);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    on<UpdateTransactionEvent>(_onUpdateTransaction);

    _transactionsSubscription = walletRepository.onTransactionsChanged.listen((_) {
      add(LoadWalletDataEvent());
    });
  }

  @override
  Future<void> close() {
    _transactionsSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadWalletData(LoadWalletDataEvent event, Emitter<BaseWalletState> emit) async {
    emit(WalletLoading());

    final result = await getTransactions(NoParams());

    result.fold(
      (failure) => emit(const WalletError("Erro ao carregar dados")),
      (transactions) async {
        final totalBalance = await getTotalBalance(NoParams());
        final totalIncome = await getTotalIncome(NoParams());
        final totalExpense = await getTotalExpense(NoParams());
        final monthlySavings = await getMonthlySavings(NoParams());
        emit(
          WalletLoaded(
            transactions: transactions,
            totalBalance: totalBalance.fold((l) => 0.0, (r) => r),
            totalIncome: totalIncome.fold((l) => 0.0, (r) => r),
            totalExpense: totalExpense.fold((l) => 0.0, (r) => r),
            monthlySavings: monthlySavings.fold((l) => 0.0, (r) => r),
          ),
        );
      },
    );
  }

  Future<void> _onGetTransactions(GetTransactionsEvent event, Emitter<BaseWalletState> emit) async {
    emit(WalletLoading());

    final result = await getTransactions(NoParams());

    result.fold(
      (failure) => emit(const WalletError("Erro ao carregar dados")),
      (transactions) => emit(WalletTransactionsLoaded(transactions)),
    );
  }

  Future<void> _onAddTransaction(AddTransactionEvent event, Emitter<BaseWalletState> emit) async {
    emit(WalletLoading());

    final result = await addTransaction(event.transaction);
    switch (result) {
      case Left(value: final _):
        emit(const WalletError("Erro ao adicionar transação"));
        return;
      case Right(value: final _):
        final totalBalance = await getTotalBalance(NoParams());
        final totalIncome = await getTotalIncome(NoParams());
        final totalExpense = await getTotalExpense(NoParams());
        final dailyExpenseResult = await getDailyExpense(NoParams());
        final weeklyExpenseResult = await getWeeklyExpense(NoParams());
        final monthlyExpenseResult = await getMonthlyExpense(NoParams());
        emit(
          TransactionAddedSuccess(
            transaction: event.transaction,
            totalBalance: totalBalance.fold((l) => 0.0, (r) => r),
            totalIncome: totalIncome.fold((l) => 0.0, (r) => r),
            totalExpense: totalExpense.fold((l) => 0.0, (r) => r),
            dailyExpense: dailyExpenseResult.fold((l) => 0.0, (r) => r),
            weeklyExpense: weeklyExpenseResult.fold((l) => 0.0, (r) => r),
            monthlyExpense: monthlyExpenseResult.fold((l) => 0.0, (r) => r),
          ),
        );
        return;
    }
  }

  Future<void> _onDeleteTransaction(DeleteTransactionEvent event, Emitter<BaseWalletState> emit) async {
    emit(WalletLoading());

    final result = await deleteTransaction(event.transactionId);
    result.fold(
      (failure) => emit(const WalletError("Erro ao deletar transação")),
      (_) => {},
    );
  }

  Future<void> _onUpdateTransaction(UpdateTransactionEvent event, Emitter<BaseWalletState> emit) async {
    emit(WalletLoading());

    final result = await updateTransaction(event.transaction);
    result.fold(
      (failure) => emit(const WalletError("Erro ao atualizar transação")),
      (_) => {},
    );
  }

  Future<void> _onGetTransaction(GetTransactionEvent event, Emitter<BaseWalletState> emit) async {
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
