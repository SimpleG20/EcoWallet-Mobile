part of 'wallet_bloc.dart';

abstract class BaseWalletState extends Equatable {
  const BaseWalletState();

  @override
  List<Object> get props => [];
}

class WalletInitial extends BaseWalletState {}

class WalletLoading extends BaseWalletState {}

class WalletLoaded extends BaseWalletState {
  final List<Transaction> transactions;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final double monthlySavings;

  const WalletLoaded({
    required this.transactions,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.monthlySavings,
  });

  @override
  List<Object> get props =>
      [transactions, totalBalance, totalIncome, totalExpense, monthlySavings];
}

class WalletError extends BaseWalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object> get props => [message];
}

class WalletTransactionLoaded extends BaseWalletState {
  final Transaction transaction;

  const WalletTransactionLoaded(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class WalletTransactionsLoaded extends BaseWalletState {
  final List<Transaction> transactions;

  const WalletTransactionsLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}
