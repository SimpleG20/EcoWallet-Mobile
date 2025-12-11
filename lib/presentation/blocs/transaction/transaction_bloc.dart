import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecowallet/core/usecase/usecase.dart';
import 'package:ecowallet/domain/usecases/add_transaction.dart';
import 'package:ecowallet/domain/usecases/get_all_transactions.dart';
import 'package:ecowallet/domain/usecases/delete_transaction.dart';
import 'package:ecowallet/domain/usecases/get_balance.dart';
import 'package:ecowallet/presentation/blocs/transaction/transaction_event.dart';
import 'package:ecowallet/presentation/blocs/transaction/transaction_state.dart';

/// BLoC for managing transaction state
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc({
    required this.addTransaction,
    required this.getAllTransactions,
    required this.deleteTransaction,
    required this.getBalance,
  }) : super(const TransactionState()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransactionEvent>(_onAddTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    on<RefreshBalance>(_onRefreshBalance);
  }

  final AddTransaction addTransaction;
  final GetAllTransactions getAllTransactions;
  final DeleteTransaction deleteTransaction;
  final GetBalance getBalance;

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    final result = await getAllTransactions(const NoParams());
    final balanceResult = await getBalance(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: failure.message ?? 'Failed to load transactions',
        ),
      ),
      (transactions) {
        final balance = balanceResult.getOrElse((l) => 0.0);
        emit(
          state.copyWith(
            status: TransactionStatus.success,
            transactions: transactions,
            balance: balance,
          ),
        );
      },
    );
  }

  Future<void> _onAddTransaction(
    AddTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    final result = await addTransaction(
      AddTransactionParams(transaction: event.transaction),
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: failure.message ?? 'Failed to add transaction',
        ),
      ),
      (transaction) async {
        // Reload transactions after adding
        final transactionsResult = await getAllTransactions(const NoParams());
        final balanceResult = await getBalance(const NoParams());
        
        transactionsResult.fold(
          (failure) => emit(
            state.copyWith(
              status: TransactionStatus.error,
              errorMessage: failure.message ?? 'Failed to reload transactions',
            ),
          ),
          (transactions) {
            final balance = balanceResult.getOrElse((l) => 0.0);
            emit(
              state.copyWith(
                status: TransactionStatus.success,
                transactions: transactions,
                balance: balance,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    final result = await deleteTransaction(
      DeleteTransactionParams(id: event.transactionId),
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: failure.message ?? 'Failed to delete transaction',
        ),
      ),
      (_) async {
        // Reload transactions after deleting
        final transactionsResult = await getAllTransactions(const NoParams());
        final balanceResult = await getBalance(const NoParams());
        
        transactionsResult.fold(
          (failure) => emit(
            state.copyWith(
              status: TransactionStatus.error,
              errorMessage: failure.message ?? 'Failed to reload transactions',
            ),
          ),
          (transactions) {
            final balance = balanceResult.getOrElse((l) => 0.0);
            emit(
              state.copyWith(
                status: TransactionStatus.success,
                transactions: transactions,
                balance: balance,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onRefreshBalance(
    RefreshBalance event,
    Emitter<TransactionState> emit,
  ) async {
    final balanceResult = await getBalance(const NoParams());

    balanceResult.fold(
      (failure) => emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: failure.message ?? 'Failed to refresh balance',
        ),
      ),
      (balance) => emit(state.copyWith(balance: balance)),
    );
  }
}
