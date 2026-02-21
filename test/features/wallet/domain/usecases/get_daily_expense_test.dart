import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/wallet/domain/usecases/get_daily_expense.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'add_transaction_test.dart';

void main() {
  late GetDailyExpense usecase;
  late MockWalletRepository mockWalletRepository;

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    usecase = GetDailyExpense(mockWalletRepository);
  });

  group('GetDailyExpense Usecase', () {
    test('should return daily expense when get succeeds', () async {
      // Arrange
      const testDailyExpense = 75.0;
      when(() => mockWalletRepository.getDailyExpense())
          .thenAnswer((_) async => Right(testDailyExpense));

      // Act
      final result = await usecase.call(NoParams());

      // Assert
      expect(result, Right(testDailyExpense));
      verify(() => mockWalletRepository.getDailyExpense()).called(1);
    });

    test('should return failure when get fails', () async {
      // Arrange
      when(() => mockWalletRepository.getDailyExpense())
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
