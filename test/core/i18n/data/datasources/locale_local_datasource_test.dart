import 'dart:ui' as ui;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_wallet/core/i18n/data/datasources/locale_local_datasource.dart';
import 'package:eco_wallet/core/i18n/domain/models/app_locale.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late LocaleLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    dataSource = LocaleLocalDataSourceImpl(mockPrefs);
  });

  group('getSavedLocale', () {
    test('should return AppLocale when both language and country codes are saved', () async {
      // Arrange
      when(() => mockPrefs.getString('app_locale_language')).thenReturn('pt');
      when(() => mockPrefs.getString('app_locale_country')).thenReturn('BR');

      // Act
      final result = await dataSource.getSavedLocale();

      // Assert
      expect(result, isNotNull);
      expect(result?.languageCode, 'pt');
      expect(result?.countryCode, 'BR');
      verify(() => mockPrefs.getString('app_locale_language')).called(1);
      verify(() => mockPrefs.getString('app_locale_country')).called(1);
    });

    test('should return AppLocale with null country code when only language is saved', () async {
      // Arrange
      when(() => mockPrefs.getString('app_locale_language')).thenReturn('en');
      when(() => mockPrefs.getString('app_locale_country')).thenReturn(null);

      // Act
      final result = await dataSource.getSavedLocale();

      // Assert
      expect(result, isNotNull);
      expect(result?.languageCode, 'en');
      expect(result?.countryCode, isNull);
      verify(() => mockPrefs.getString('app_locale_language')).called(1);
      verify(() => mockPrefs.getString('app_locale_country')).called(1);
    });

    test('should return null when no language code is saved', () async {
      // Arrange
      when(() => mockPrefs.getString('app_locale_language')).thenReturn(null);

      // Act
      final result = await dataSource.getSavedLocale();

      // Assert
      expect(result, isNull);
      verify(() => mockPrefs.getString('app_locale_language')).called(1);
      verifyNever(() => mockPrefs.getString('app_locale_country'));
    });
  });

  group('saveLocale', () {
    test('should save both language and country codes when country code is not null', () async {
      // Arrange
      const locale = AppLocale(languageCode: 'pt', countryCode: 'BR');
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      // Act
      await dataSource.saveLocale(locale);

      // Assert
      verify(() => mockPrefs.setString('app_locale_language', 'pt')).called(1);
      verify(() => mockPrefs.setString('app_locale_country', 'BR')).called(1);
      verifyNever(() => mockPrefs.remove(any()));
    });

    test('should save language code and remove country code when country code is null', () async {
      // Arrange
      const locale = AppLocale(languageCode: 'en');
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

      // Act
      await dataSource.saveLocale(locale);

      // Assert
      verify(() => mockPrefs.setString('app_locale_language', 'en')).called(1);
      verify(() => mockPrefs.remove('app_locale_country')).called(1);
      verifyNever(() => mockPrefs.setString('app_locale_country', any()));
    });

    test('should handle AppLocale.english correctly', () async {
      // Arrange
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

      // Act
      await dataSource.saveLocale(AppLocale.english);

      // Assert
      verify(() => mockPrefs.setString('app_locale_language', 'en')).called(1);
      verify(() => mockPrefs.remove('app_locale_country')).called(1);
    });

    test('should handle AppLocale.portuguese correctly', () async {
      // Arrange
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      // Act
      await dataSource.saveLocale(AppLocale.portuguese);

      // Assert
      verify(() => mockPrefs.setString('app_locale_language', 'pt')).called(1);
      verify(() => mockPrefs.setString('app_locale_country', 'BR')).called(1);
      verifyNever(() => mockPrefs.remove(any()));
    });
  });

  group('getSystemLocale', () {
    test('should return AppLocale with system language and country codes', () {
      // Note: This test verifies the method works, but the actual locale
      // returned depends on the test environment's platform dispatcher.
      // Act
      final result = dataSource.getSystemLocale();

      // Assert
      expect(result, isNotNull);
      expect(result.languageCode, isNotEmpty);
      // countryCode can be null or non-null depending on the system locale
    });

    test('should create AppLocale matching PlatformDispatcher locale', () {
      // Act
      final result = dataSource.getSystemLocale();
      final platformLocale = ui.PlatformDispatcher.instance.locale;

      // Assert
      expect(result.languageCode, platformLocale.languageCode);
      expect(result.countryCode, platformLocale.countryCode);
    });
  });
}
