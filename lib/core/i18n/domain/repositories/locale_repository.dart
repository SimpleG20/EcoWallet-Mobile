import 'package:fpdart/fpdart.dart';
import '../models/app_locale.dart';

abstract class LocaleRepository {
    Future<Option<AppLocale>> getSavedLocale();
    Future<Either<LocaleError, Unit>> saveLocale(AppLocale locale);

    AppLocale getSystemLocale();
}

class LocaleError {
    final String message;

    const LocaleError(this.message);
}