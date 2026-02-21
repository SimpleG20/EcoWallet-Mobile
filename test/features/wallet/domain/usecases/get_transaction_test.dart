import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/features/wallet/domain/usecases/get_transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'add_transaction_test.dart';

void main() {
  late GetTransaction usecase;
  late MockWalletRepository mockWalletRepository;
  setUpAll(() {
    registerFallbackValue(FakeTransaction());
  });
  setUp(() {
    mockWalletRepository = MockWalletRepository();
    usecase = GetTransaction(mockWalletRepository);
  });

  group('GetTransaction Usecase', () {
    final testTransactionId = 'test_id';

    test('should return transaction when get succeeds', () async {
      // Arrange
      when(() => mockWalletRepository.getTransactionById(any()))
          .thenAnswer((_) async => Right(testTransaction));

      // Act
      final result = await usecase.call(testTransactionId);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockWalletRepository.getTransactionById(testTransactionId))
          .called(1);
    });

    test('should return failure when get fails', () async {
      // Arrange
      when(() => mockWalletRepository.getTransactionById(any()))
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
