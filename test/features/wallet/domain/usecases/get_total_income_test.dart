import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/core/usecases/base_usecase.dart';
import 'package:eco_wallet/features/wallet/domain/usecases/get_total_income.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'add_transaction_test.dart';

void main() {
  late GetTotalIncome usecase;
  late MockWalletRepository mockWalletRepository;

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    usecase = GetTotalIncome(mockWalletRepository);
  });

  group('GetTotalIncome Usecase', () {
    test('should return total income when get succeeds', () async {
      // Arrange
      const testIncome = 2000.0;
      when(() => mockWalletRepository.getTotalIncome())
          .thenAnswer((_) async => Right(testIncome));

      // Act
      final result = await usecase.call(NoParams());

      // Assert
      expect(result, Right(testIncome));
      verify(() => mockWalletRepository.getTotalIncome()).called(1);
    });

    test('should return failure when get fails', () async {
      // Arrange
      when(() => mockWalletRepository.getTotalIncome())
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
