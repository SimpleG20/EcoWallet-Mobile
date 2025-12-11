import 'package:equatable/equatable.dart';
import 'package:ecowallet/domain/entities/transaction.dart';

/// Base class for transaction events
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all transactions
class LoadTransactions extends TransactionEvent {
  const LoadTransactions();
}

/// Event to add a new transaction
class AddTransactionEvent extends TransactionEvent {
  const AddTransactionEvent(this.transaction);

  final Transaction transaction;

  @override
  List<Object?> get props => [transaction];
}

/// Event to delete a transaction
class DeleteTransactionEvent extends TransactionEvent {
  const DeleteTransactionEvent(this.transactionId);

  final String transactionId;

  @override
  List<Object?> get props => [transactionId];
}

/// Event to refresh balance
class RefreshBalance extends TransactionEvent {
  const RefreshBalance();
}
