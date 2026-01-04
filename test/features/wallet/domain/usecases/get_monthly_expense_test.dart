import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/features/wallet/domain/usecases/get_monthly_expense.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'add_transaction_test.dart';

void main() {
  late GetMonthlyExpense usecase;
  late MockWalletRepository mockWalletRepository;

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    usecase = GetMonthlyExpense(mockWalletRepository);
  });

  group('GetMonthlyExpense Usecase', () {
    const initialDay = 1;
    test('should return monthly expense when get succeeds', () async {
      // Arrange
      const testMonthlyExpense = 1200.0;
      when(() => mockWalletRepository.getCurrentMonthExpense(initialDay))
          .thenAnswer((_) async => Right(testMonthlyExpense));

      // Act
      final result = await usecase.call(initialDay);

      // Assert
      expect(result, Right(testMonthlyExpense));
      verify(() => mockWalletRepository.getCurrentMonthExpense(initialDay))
          .called(1);
    });

    test('should return failure when get fails', () async {
      // Arrange
      when(() => mockWalletRepository.getCurrentMonthExpense(initialDay))
          .thenAnswer((_) async => Left(CacheFailure('Error')));

      // Act
      final result = await usecase.call(initialDay);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected failure'),
      );
    });
  });
}
