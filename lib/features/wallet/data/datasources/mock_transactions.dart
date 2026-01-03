import '../../../../core/enums/enums.dart';
import '../../domain/entities/transaction.dart';
import 'package:uuid/uuid.dart';

// Mock transactions for testing or seeding
final List<Transaction> kMockTransactions = [
  Transaction(
    id: const Uuid().v4(),
    userId: '',
    name: 'Salário Mensal',
    amountCents: 500000, // 5000.00
    date: DateTime.now(),
    type: ETransactionType.income,
    category: ETransactionCategory.salary,
  ),
  Transaction(
    id: const Uuid().v4(),
    userId: '',
    name: 'Supermercado',
    amountCents: 45050, // 450.50
    date: DateTime.now().subtract(const Duration(days: 1)),
    type: ETransactionType.expense,
    category: ETransactionCategory.food,
  ),
  Transaction(
    id: const Uuid().v4(),
    userId: '',
    name: 'Freelance Design',
    amountCents: 80000, // 800.00
    date: DateTime.now().subtract(const Duration(days: 1)),
    type: ETransactionType.income,
    category: ETransactionCategory.others,
  ),
  Transaction(
    id: const Uuid().v4(),
    userId: '',
    name: 'Uber',
    amountCents: 2490, // 24.90
    date: DateTime.now().subtract(const Duration(days: 2)),
    type: ETransactionType.expense,
    category: ETransactionCategory.transport,
  ),
  Transaction(
    id: const Uuid().v4(),
    userId: '',
    name: 'Jantar com Amigos',
    amountCents: 12075, // 120.75
    date: DateTime.now().subtract(const Duration(days: 3)),
    type: ETransactionType.expense,
    category: ETransactionCategory.entertainment,
  ),
  Transaction(
    id: const Uuid().v4(),
    userId: '',
    name: 'Venda de Item Usado',
    amountCents: 15000, // 150.00
    date: DateTime.now().subtract(const Duration(days: 3)),
    type: ETransactionType.income,
    category: ETransactionCategory.others,
  ),
];

