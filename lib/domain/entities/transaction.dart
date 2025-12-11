import 'package:equatable/equatable.dart';

/// Transaction type enum
enum TransactionType {
  income,
  expense,
}

/// Transaction entity representing a financial transaction
class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.type,
    required this.date,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final double amount;
  final String description;
  final String category;
  final TransactionType type;
  final DateTime date;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        id,
        amount,
        description,
        category,
        type,
        date,
        notes,
        createdAt,
        updatedAt,
      ];

  /// Copy with method for immutability
  Transaction copyWith({
    String? id,
    double? amount,
    String? description,
    String? category,
    TransactionType? type,
    DateTime? date,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Transaction(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        description: description ?? this.description,
        category: category ?? this.category,
        type: type ?? this.type,
        date: date ?? this.date,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
