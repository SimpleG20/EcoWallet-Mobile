part of 'wallet_bloc.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
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

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object> get props => [message];
}

class WalletTransactionLoaded extends WalletState {
  final Transaction transaction;

  const WalletTransactionLoaded(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class WalletTransactionsLoaded extends WalletState {
  final List<Transaction> transactions;

  const WalletTransactionsLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}
