import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/wallet/domain/usecases/get_transactions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'add_transaction_test.dart';

void main() {
  late GetTransactions usecase;
  late MockWalletRepository mockWalletRepository;

  setUpAll(() {
    registerFallbackValue(FakeTransaction());
  });

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    usecase = GetTransactions(mockWalletRepository);
  });

  group('GetTransactions Usecase', () {
    test('should return list of transactions when get succeeds', () async {
      // Arrange
      final testTransactions = [testTransaction];
      when(() => mockWalletRepository.getTransactions())
          .thenAnswer((_) async => Right(testTransactions));

      // Act
      final result = await usecase.call(NoParams());

      // Assert
      expect(result.isRight(), true);
      verify(() => mockWalletRepository.getTransactions()).called(1);
    });

    test('should return failure when get fails', () async {
      // Arrange
      when(() => mockWalletRepository.getTransactions())
          .thenAnswer((_) async => Left(CacheFailure('Error')));

      // Act
      final result = await usecase.call(NoParams());
      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected a failure but got success'),
      );
    });

    test('should return empty list when there are no transactions', () async {
      // Arrange
      when(() => mockWalletRepository.getTransactions())
          .thenAnswer((_) async => Right([]));

      // Act
      final result = await usecase.call(NoParams());

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected success but got failure'),
        (transactions) => expect(transactions, isEmpty),
      );
      verify(() => mockWalletRepository.getTransactions()).called(1);
    });
  });
}
