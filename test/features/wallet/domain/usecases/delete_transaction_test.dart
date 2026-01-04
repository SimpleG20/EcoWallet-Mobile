import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/features/wallet/domain/usecases/delete_transaction.dart';

import 'add_transaction_test.dart';

void main() {
  late DeleteTransaction usecase;
  late MockWalletRepository mockWalletRepository;

  setUpAll(() {
    registerFallbackValue(FakeTransaction());
  });

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    usecase = DeleteTransaction(mockWalletRepository);
  });

  group('DeleteTransaction Usecase', () {
    final testTransactionId = 'test_id';

    test('should return unit when delete succeeds', () async {
      // Arrange
      when(() => mockWalletRepository.deleteTransaction(any()))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await usecase.call(testTransactionId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockWalletRepository.deleteTransaction(testTransactionId))
          .called(1);
    });

    test('should return failure when delete fails', () async {
      // Arrange
      when(() => mockWalletRepository.deleteTransaction(any()))
          .thenAnswer((_) async => Left(CacheFailure('Error')));

      // Act
      final result = await usecase.call(testTransactionId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected a failure but got success'),
      );
    });
  });
}
