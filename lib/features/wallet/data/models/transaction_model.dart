import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';

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
    return TransactionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: json['amount'] as int,
      cents: json['cents'] as int,
      type: json['type'] as ETransactionType,
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
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
}
