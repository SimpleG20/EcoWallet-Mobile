import '../../domain/entities/transaction.dart';
import 'package:uuid/uuid.dart';

// Lista constante para testes ou "seed" (popular banco)
final List<Transaction> kMockTransactions = [
  Transaction(
    id: const Uuid()
        .v4(), // Ou strings fixas '1', '2' se preferir previsibilidade
    name: 'Salário Mensal',
    amount: 5000,
    cents: 0,
    date: DateTime.now(), // Hoje
    type: ETransactionType.income,
    category: 'Salário',
  ),
  Transaction(
    id: const Uuid().v4(),
    name: 'Supermercado',
    amount: 450,
    cents: 50,
    date: DateTime.now().subtract(const Duration(days: 1)), // Ontem
    type: ETransactionType.expense,
    category: 'Alimentação',
  ),
  Transaction(
    id: const Uuid().v4(),
    name: 'Freelance Design',
    amount: 800,
    cents: 0,
    date: DateTime.now().subtract(const Duration(days: 1)),
    type: ETransactionType.income,
    category: 'Trabalho',
  ),
  Transaction(
    id: const Uuid().v4(),
    name: 'Uber',
    amount: 24,
    cents: 90,
    date: DateTime.now().subtract(const Duration(days: 2)),
    type: ETransactionType.expense,
    category: 'Transporte',
  ),
  Transaction(
    id: const Uuid().v4(),
    name: 'Jantar com Amigos',
    amount: 120,
    cents: 75,
    date: DateTime.now().subtract(const Duration(days: 3)),
    type: ETransactionType.expense,
    category: 'Lazer',
  ),
  Transaction(
    id: const Uuid().v4(),
    name: 'Venda de Item Usado',
    amount: 150,
    cents: 0,
    date: DateTime.now().subtract(const Duration(days: 3)),
    type: ETransactionType.income,
    category: 'Vendas',
  ),
];
