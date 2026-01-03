import 'package:equatable/equatable.dart';

import '../../../../core/enums/enums.dart';

class Transaction extends Equatable {
  final String id;
  final String name;
  final int amount;
  final int cents;
  final DateTime date;
  final ETransactionType type;
  final String category;

  const Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.cents,
    required this.type,
    required this.date,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, amount, cents, date, type, category];

  @override
  String toString() {
    return 'Transaction id: $id, name: $name, amount: $amount, cents: $cents, type: $type, date: $date, category: $category';
  }
}
