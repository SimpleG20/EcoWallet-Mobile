import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/wallet/domain/usecases/get_weekly_expense.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'add_transaction_test.dart';

void main() {
  late GetWeeklyExpense usecase;
  late MockWalletRepository mockWalletRepository;

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    usecase = GetWeeklyExpense(mockWalletRepository);
  });

  group('GetWeeklyExpense Usecase', () {
    test('should return weekly expense when get succeeds', () async {
      // Arrange
      const testWeeklyExpense = 300.0;
      when(() => mockWalletRepository.getWeeklyExpense())
          .thenAnswer((_) async => Right(testWeeklyExpense));

      // Act
      final result = await usecase.call(NoParams());

      // Assert
      expect(result, Right(testWeeklyExpense));
      verify(() => mockWalletRepository.getWeeklyExpense()).called(1);
    });

    test('should return failure when get fails', () async {
      // Arrange
      when(() => mockWalletRepository.getWeeklyExpense())
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
