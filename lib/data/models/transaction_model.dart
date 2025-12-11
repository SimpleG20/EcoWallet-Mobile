import 'package:ecowallet/domain/entities/transaction.dart';
import 'package:ecowallet/data/datasources/database/database.dart' as db;

/// Extension to convert Drift Transaction to Domain Transaction
extension TransactionModelMapper on db.Transaction {
  Transaction toDomain() => Transaction(
        id: id,
        amount: amount,
        description: description,
        category: category,
        type: type == 'income' ? TransactionType.income : TransactionType.expense,
        date: date,
        notes: notes,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

/// Extension to convert Domain Transaction to Drift TransactionsCompanion
extension TransactionDomainMapper on Transaction {
  db.TransactionsCompanion toCompanion() => db.TransactionsCompanion.insert(
        id: id,
        amount: amount,
        description: description,
        category: category,
        type: type == TransactionType.income ? 'income' : 'expense',
        date: date,
        notes: db.Value(notes),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  db.Transaction toDrift() => db.Transaction(
        id: id,
        amount: amount,
        description: description,
        category: category,
        type: type == TransactionType.income ? 'income' : 'expense',
        date: date,
        notes: notes,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
