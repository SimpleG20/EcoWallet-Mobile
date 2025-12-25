import 'package:eco_wallet/l10n/app_localizations.dart';

class AppValidators {
  static String? validateTitle(String? value, AppLocalizations loc) {
    if (value == null || value.trim().isEmpty) {
      return loc.errorTitleEmpty;
    }
    return null;
  }

  static String? validateAmount(String? value, AppLocalizations loc) {
    if (value == null || value.isEmpty) {
      return loc.errorAmountInvalid;
    }

    final parsedValue = double.tryParse(value.replaceAll(',', '.'));
    if (parsedValue == null || parsedValue <= 0) {
      return loc.errorAmountInvalid;
    }

    return null;
  }
}
