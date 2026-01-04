import 'package:eco_wallet/core/enums/enums.dart';
import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';
import 'package:eco_wallet/features/wallet/domain/repositories/base_wallet_repository.dart';
import 'package:eco_wallet/features/wallet/domain/usecases/wallet_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockWalletRepository extends Mock implements BaseWalletRepository {}

class FakeTransaction extends Fake implements Transaction {}

final testTransaction = Transaction(
  id: 'test_id',
  userId: 'user_id',
  name: 'Test Transaction',
  amountCents: 1000,
  type: ETransactionType.income,
  date: DateTime.now(),
  category: ETransactionCategory.others,
);

void main() {
  late AddTransaction usecase;
  late MockWalletRepository mockWalletRepository;

  setUpAll(() {
    registerFallbackValue(FakeTransaction());
  });

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    usecase = AddTransaction(mockWalletRepository);
  });

  group('AddTransaction Usecase', () {
    test('should return unit when add succeeds', () async {
      // Arrange
      when(() => mockWalletRepository.addTransaction(any()))
          .thenAnswer((_) async => Right(testTransaction));

      // Act
      final result = await usecase.call(testTransaction);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockWalletRepository.addTransaction(testTransaction))
          .called(1);
    });

    test('should return failure when add fails', () async {
      // Arrange
      when(() => mockWalletRepository.addTransaction(any()))
          .thenAnswer((_) async => Left(CacheFailure('Error')));

      // Act
      final result = await usecase.call(testTransaction);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected failure'),
      );
    });
  });
}
