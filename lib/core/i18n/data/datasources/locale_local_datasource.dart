import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/app_locale.dart';

abstract class LocaleLocalDataSource {
    Future<AppLocale?> getSavedLocale();
    Future<void> saveLocale(AppLocale locale);
    AppLocale getSystemLocale();
}

class LocaleLocalDataSourceImpl implements LocaleLocalDataSource {
    final SharedPreferences _prefs;
    static const String _localeKey = 'app_locale';

    const LocaleLocalDataSourceImpl(this._prefs);

    @override
    Future<AppLocale?> getSavedLocale() async {
        final languageCode = _prefs.getString('${_localeKey}_language');
        if (languageCode == null) return null;

        final countryCode = _prefs.getString('${_localeKey}_country');
        return AppLocale(languageCode: languageCode, countryCode: countryCode);
    }

    @override
    Future<void> saveLocale(AppLocale locale) async {
        await _prefs.setString('${_localeKey}_language', locale.languageCode);
        await _prefs.setString('${_localeKey}_country', locale.countryCode);
    }

    @override
    AppLocale getSystemLocale() {
        final locale = ui.PlatformDispatcher.instance.locale;
        return AppLocale(
            languageCode: locale.languageCode, 
            countryCode: locale.countryCode
        );
    }
}
