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

  const WalletLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
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
