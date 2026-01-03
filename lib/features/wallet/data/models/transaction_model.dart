import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';

import '../../../../core/enums/enums.dart';

class TransactionModel extends Transaction {
  const TransactionModel(
      {required super.id,
      required super.name,
      required super.amount,
      required super.cents,
      required super.type,
      required super.date,
      required super.category});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawType = json['type'];
    final ETransactionType parsedType = rawType is ETransactionType
        ? rawType
        : ETransactionType.values.firstWhere(
            (e) => e.toString() == rawType.toString() || e.name == rawType.toString(),
          );

    return TransactionModel(
      id: json['id'],
      name: json['name'],
      amount: json['amount'] as int,
      cents: json['cents'] as int,
      type: parsedType,
      date: DateTime.parse(json['date']),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'cents': cents,
      'type': type.toString(),
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  static TransactionModel fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      name: transaction.name,
      amount: transaction.amount,
      cents: transaction.cents,
      type: transaction.type,
      date: transaction.date,
      category: transaction.category,
    );
  }
}
