import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/wallet/domain/usecases/get_total_expense.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'add_transaction_test.dart';

void main() {
  late GetTotalExpense usecase;
  late MockWalletRepository mockWalletRepository;

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    usecase = GetTotalExpense(mockWalletRepository);
  });

  group('GetTotalExpense Usecase', () {
    test('should return total expense when get succeeds', () async {
      // Arrange
      const testExpense = 1500.0;
      when(() => mockWalletRepository.getTotalExpense())
          .thenAnswer((_) async => Right(testExpense));

      // Act
      final result = await usecase.call(NoParams());

      // Assert
      expect(result, Right(testExpense));
      verify(() => mockWalletRepository.getTotalExpense()).called(1);
    });

    test('should return failure when get fails', () async {
      // Arrange
      when(() => mockWalletRepository.getTotalExpense())
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
