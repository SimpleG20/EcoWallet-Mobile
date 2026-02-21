import 'package:equatable/equatable.dart';

import '../../../../core/enums/enums.dart';

/// Represents a financial transaction (income or expense).
class Transaction extends Equatable {
  /// Unique identifier for the transaction.
  final String id;

  /// ID of the user who owns this transaction.
  final String userId;

  /// Display name/description of the transaction.
  final String name;

  /// Amount in cents (e.g., 1234 = $12.34).
  final int amountCents;

  /// Date when the transaction occurred.
  final DateTime date;

  /// Type of transaction (income or expense).
  final ETransactionType type;

  /// Category of the transaction.
  final ETransactionCategory category;

  const Transaction({
    required this.id,
    required this.userId,
    required this.name,
    required this.amountCents,
    required this.type,
    required this.date,
    required this.category,
  });

  /// Returns the amount as a double (e.g., 1234 cents = 12.34).
  double get amountAsDouble => amountCents / 100.0;

  /// Returns the integer part of the amount.
  int get amount => amountCents ~/ 100;

  /// Returns the cents part of the amount.
  int get cents => amountCents % 100;

  @override
  List<Object?> get props => [id, userId, name, amountCents, date, type, category];

  @override
  String toString() {
    return 'Transaction(id: $id, userId: $userId, name: $name, amountCents: $amountCents, type: $type, date: $date, category: $category)';
  }
}

