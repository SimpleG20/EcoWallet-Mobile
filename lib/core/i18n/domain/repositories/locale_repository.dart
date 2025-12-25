import 'package:fpdart/fpdart.dart';
import '../models/app_locale.dart';

abstract class LocaleRepository {
    Future<Option<AppLocale>> getSavedLocale();
    Future<Either<LocaleError, Unit>> saveLocale(AppLocale locale);

    AppLocale getSystemLocale();
}

/// Represents an error that occurred during locale operations.
///
/// This error can occur in the following scenarios:
/// - SharedPreferences read/write failures
/// - Locale persistence issues
/// - Invalid locale data
class LocaleError {
    final String message;

    const LocaleError(this.message);
}