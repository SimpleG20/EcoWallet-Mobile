part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class GetTransactionsEvent extends WalletEvent {}

class GetTransactionEvent extends WalletEvent {
  final String transactionId;

  const GetTransactionEvent(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}

class AddTransactionEvent extends WalletEvent {
  final int initialDay;
  final Transaction transaction;
  final BudgetPreferences budgetPreferences;

  const AddTransactionEvent(
    this.initialDay,
    this.transaction, {
    this.budgetPreferences = const BudgetPreferences(),
  });

  @override
  List<Object> get props => [initialDay, transaction, budgetPreferences];
}

class DeleteTransactionEvent extends WalletEvent {
  final String transactionId;

  const DeleteTransactionEvent(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}

class DeleteAllTransactionsEvent extends WalletEvent {
  final String userId;

  const DeleteAllTransactionsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateTransactionEvent extends WalletEvent {
  final Transaction transaction;

  const UpdateTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class LoadWalletDataEvent extends WalletEvent {
  final BudgetPreferences budgetPreferences;
  const LoadWalletDataEvent(
      {this.budgetPreferences = const BudgetPreferences()});

  @override
  List<Object> get props => [budgetPreferences];
}
