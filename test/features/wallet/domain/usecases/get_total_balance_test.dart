import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/wallet/domain/usecases/get_total_balance.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'add_transaction_test.dart';

void main() {
  late GetTotalBalance usecase;
  late MockWalletRepository mockWalletRepository;

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    usecase = GetTotalBalance(mockWalletRepository);
  });

  group('GetTotalBalance Usecase', () {
    test('should return total balance when get succeeds', () async {
      // Arrange
      const testBalance = 1500.0;
      when(() => mockWalletRepository.getTotalBalance())
          .thenAnswer((_) async => Right(testBalance));

      // Act
      final result = await usecase.call(NoParams());

      // Assert
      expect(result, Right(testBalance));
      verify(() => mockWalletRepository.getTotalBalance()).called(1);
    });

    test('should return failure when get fails', () async {
      // Arrange
      when(() => mockWalletRepository.getTotalBalance())
          .thenAnswer((_) async => Left(CacheFailure('Error')));

      // Act
      final result = await usecase.call(NoParams());

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected failure'),
      );
    });
  });
}

