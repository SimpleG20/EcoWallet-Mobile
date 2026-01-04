import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/features/wallet/domain/usecases/update_transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'add_transaction_test.dart';

void main() {
  late UpdateTransaction usecase;
  late MockWalletRepository mockWalletRepository;

  setUpAll(() {
    registerFallbackValue(FakeTransaction());
  });

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    usecase = UpdateTransaction(mockWalletRepository);
  });

  group('UpdateTransaction Usecase', () {
    test('should call updateTransaction on the repository', () async {
      // Arrange
      when(() => mockWalletRepository.updateTransaction(any()))
          .thenAnswer((_) async => Right(testTransaction));

      // Act
      final result = await usecase.call(testTransaction);

      // Assert
      expect(result.isRight(), true);
      verify(() => mockWalletRepository.updateTransaction(testTransaction))
          .called(1);
    });

    test('should return failure when update fails', () async {
      // Arrange
      when(() => mockWalletRepository.updateTransaction(any()))
          .thenAnswer((_) async => Left(CacheFailure('Error')));

      // Act
      final result = await usecase.call(testTransaction);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected a failure but got success'),
      );
    });
  });
}
