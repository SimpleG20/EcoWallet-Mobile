import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';

class TransactionGroup {
  final DateTime date;
  final List<Transaction> transactions;

  TransactionGroup({required this.date, required this.transactions});
}
