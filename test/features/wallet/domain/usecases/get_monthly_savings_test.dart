import 'package:eco_wallet/core/errors/base_failure.dart';
import 'package:eco_wallet/features/wallet/domain/usecases/get_monthly_savings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'add_transaction_test.dart';

void main() {
  late GetMonthlySavings usecase;
  late MockWalletRepository mockWalletRepository;

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    usecase = GetMonthlySavings(mockWalletRepository);
  });

  group('GetMonthlySavings Usecase', () {
    const initialDay = 1;
    test('should return monthly savings when get succeeds', () async {
      // Arrange
      const testMonthlySavings = 300.0;
      when(() => mockWalletRepository.getMonthlySavings(initialDay))
          .thenAnswer((_) async => Right(testMonthlySavings));

      // Act
      final result = await usecase.call(initialDay);

      // Assert
      expect(result, Right(testMonthlySavings));
      verify(() => mockWalletRepository.getMonthlySavings(initialDay))
          .called(1);
    });

    test('should return failure when get fails', () async {
      // Arrange
      when(() => mockWalletRepository.getMonthlySavings(initialDay))
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
