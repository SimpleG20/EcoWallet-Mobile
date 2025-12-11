import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecowallet/domain/entities/transaction.dart';
import 'package:ecowallet/domain/repositories/transaction_repository.dart';
import 'package:ecowallet/domain/usecases/add_transaction.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late AddTransaction useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = AddTransaction(mockRepository);
  });

  final testTransaction = Transaction(
    id: '1',
    amount: 100.0,
    description: 'Test Transaction',
    category: 'Food & Dining',
    type: TransactionType.expense,
    date: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  test('should add transaction through repository', () async {
    // Arrange
    when(() => mockRepository.addTransaction(testTransaction))
        .thenAnswer((_) async => Right(testTransaction));

    // Act
    final result = await useCase(AddTransactionParams(transaction: testTransaction));

    // Assert
    expect(result, Right<dynamic, Transaction>(testTransaction));
    verify(() => mockRepository.addTransaction(testTransaction));
    verifyNoMoreInteractions(mockRepository);
  });
}
