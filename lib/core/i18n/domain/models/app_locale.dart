import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_locale.freezed.dart';

@freezed
class AppLocale with _$AppLocale {
    const factory AppLocale({
        required String languageCode,
        String? countryCode,
    }) = _AppLocale;

    const AppLocale._();

    static const AppLocale english = AppLocale(languageCode: 'en');
    static const AppLocale portuguese = AppLocale(languageCode: 'pt', countryCode: 'BR');

    static const List<AppLocale> supportedLocales = [
        english,
        portuguese,
    ];

    Locale toLocale() => Locale(languageCode, countryCode);
}