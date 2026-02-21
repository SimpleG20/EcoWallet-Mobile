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
  final List<Transaction> recentTransactions;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final double monthlySavings;

  WalletLoaded({
    required this.transactions,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.monthlySavings,
  }) : recentTransactions =
            transactions.where((tx) => tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)))).toList();

  @override
  List<Object> get props => [transactions, totalBalance, totalIncome, totalExpense, monthlySavings];
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

class TransactionAddedSuccess extends BaseWalletState {
  final Transaction transaction;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final double dailyExpense;
  final double weeklyExpense;
  final double monthlyExpense;

  const TransactionAddedSuccess({
    required this.transaction,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.dailyExpense,
    required this.weeklyExpense,
    required this.monthlyExpense,
  });

  @override
  List<Object> get props => [
        transaction,
        totalBalance,
        totalIncome,
        totalExpense,
        dailyExpense,
        weeklyExpense,
        monthlyExpense,
      ];
}

