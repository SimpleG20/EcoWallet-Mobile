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
  final Transaction transaction;

  const AddTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class DeleteTransactionEvent extends WalletEvent {
  final String transactionId;

  const DeleteTransactionEvent(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}

class UpdateTransactionEvent extends WalletEvent {
  final Transaction transaction;

  const UpdateTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class LoadWalletDataEvent extends WalletEvent {}
