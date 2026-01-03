import '../../features/wallet/domain/entities/transaction.dart';
import '../enums/enums.dart';

class TransactionParsingUtils {
  /// Parses a Transaction from a JSON map, handling legacy formats.
  static Transaction parseTransactionFromJson(
      Map<String, dynamic> json, String userId) {
    // Handle type
    ETransactionType type;
    final rawType = json['type_id'] ?? json['type'];
    if (rawType is int) {
      type = rawType == 1 ? ETransactionType.income : ETransactionType.expense;
    } else {
      type = rawType?.toString() == 'income'
          ? ETransactionType.income
          : ETransactionType.expense;
    }

    // Handle category
    ETransactionCategory category;
    final rawCategory = json['category_id'] ?? json['category'];
    if (rawCategory is int) {
      category = ETransactionCategory.values.elementAtOrNull(rawCategory - 1) ??
          ETransactionCategory.others;
    } else {
      category = ETransactionCategory.values.firstWhere(
        (e) => e.name == rawCategory?.toString(),
        orElse: () => ETransactionCategory.others,
      );
    }

    // Handle amount
    int amountCents;
    if (json.containsKey('amount_cents')) {
      amountCents = json['amount_cents'] as int;
    } else {
      final amount = json['amount'] as int? ?? 0;
      final cents = json['cents'] as int? ?? 0;
      amountCents = amount * 100 + cents;
    }

    return Transaction(
      id: json['id'] as String,
      userId: userId,
      name: json['name'] as String,
      amountCents: amountCents,
      date: DateTime.parse(json['date'] as String),
      type: type,
      category: category,
    );
  }

  /// Converts a Transaction to a JSON map, using the latest format.
  static Map<String, dynamic> transactionToJson(Transaction transaction) {
    return {
      'id': transaction.id,
      'user_id': transaction.userId,
      'name': transaction.name,
      'amount_cents': transaction.amountCents,
      'date': transaction.date.toIso8601String(),
      'type_id': transaction.type == ETransactionType.income ? 1 : 2,
      'category_id': transaction.category.index + 1,
    };
  }
}
