import 'package:equatable/equatable.dart';
import 'package:ecowallet/domain/entities/transaction.dart';

/// Transaction state status
enum TransactionStatus {
  initial,
  loading,
  success,
  error,
}

/// State for transaction bloc
class TransactionState extends Equatable {
  const TransactionState({
    this.status = TransactionStatus.initial,
    this.transactions = const [],
    this.balance = 0.0,
    this.errorMessage,
  });

  final TransactionStatus status;
  final List<Transaction> transactions;
  final double balance;
  final String? errorMessage;

  TransactionState copyWith({
    TransactionStatus? status,
    List<Transaction>? transactions,
    double? balance,
    String? errorMessage,
  }) =>
      TransactionState(
        status: status ?? this.status,
        transactions: transactions ?? this.transactions,
        balance: balance ?? this.balance,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, transactions, balance, errorMessage];
}
