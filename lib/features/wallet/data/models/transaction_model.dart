import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';
import 'package:eco_wallet/core/database/db_seeds.dart';

import '../../../../core/enums/enums.dart';

/// Data model for Transaction with database serialization.
class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.amountCents,
    required super.type,
    required super.date,
    required super.category,
  });

  /// Creates a TransactionModel from a database row.
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    // Handle type: can be string (legacy) or int (new schema with type_id)
    ETransactionType parsedType;
    final rawType = json['type_id'] ?? json['type'];
    if (rawType is int) {
      parsedType = rawType == 1 ? ETransactionType.income : ETransactionType.expense;
    } else {
      final typeStr = rawType?.toString() ?? 'expense';
      parsedType = typeStr == 'income' ? ETransactionType.income : ETransactionType.expense;
    }

    // Handle category: can be string (legacy) or int (new schema with category_id)
    ETransactionCategory parsedCategory;
    final rawCategory = json['category_id'] ?? json['category'];
    if (rawCategory is int) {
      final categoryName = DbSeeds.getCategoryName(rawCategory);
      parsedCategory = ETransactionCategory.values.firstWhere(
        (e) => e.name == categoryName,
        orElse: () => ETransactionCategory.others,
      );
    } else {
      final catStr = rawCategory?.toString() ?? 'others';
      parsedCategory = ETransactionCategory.values.firstWhere(
        (e) => e.name == catStr || e.toString() == catStr,
        orElse: () => ETransactionCategory.others,
      );
    }

    // Handle amount: can be amount_cents (new) or amount+cents (legacy)
    int amountCents;
    if (json.containsKey('amount_cents')) {
      amountCents = json['amount_cents'] as int;
    } else {
      final amount = json['amount'] as int? ?? 0;
      final cents = json['cents'] as int? ?? 0;
      amountCents = amount * 100 + cents;
    }

    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      name: json['name'] as String,
      amountCents: amountCents,
      type: parsedType,
      date: DateTime.parse(json['date'] as String),
      category: parsedCategory,
    );
  }

  /// Converts this model to a database row format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'amount_cents': amountCents,
      'type_id': type == ETransactionType.income ? 1 : 2,
      'date': date.toIso8601String(),
      'category_id': DbSeeds.getCategoryId(category.name),
    };
  }

  /// Creates a TransactionModel from a Transaction entity.
  static TransactionModel fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      name: transaction.name,
      amountCents: transaction.amountCents,
      type: transaction.type,
      date: transaction.date,
      category: transaction.category,
    );
  }
}

