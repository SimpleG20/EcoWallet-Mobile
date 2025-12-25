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

    // Only support simple decimal input without thousands separators.
    // If both '.' and ',' appear, the format is ambiguous (e.g. "1,234.56" or "1.234,56"),
    // so reject it explicitly.
    if (value.contains(',') && value.contains('.')) {
      return loc.errorAmountFormat;
    }

    // Treat comma as a decimal separator only when no period is present.
    // Note: This approach does not support thousands separators. Input like "1,234"
    // will be interpreted as "1.234" (one point two three four), not as one thousand.
    // This is intentional to keep the validation simple and avoid locale-specific parsing complexity.
    final normalized = value.contains(',')
        ? value.replaceAll(',', '.')
        : value;

    final parsedValue = double.tryParse(normalized);

    if (parsedValue == null) {
      return loc.errorAmountFormat;
    }

    if (parsedValue <= 0) {
      return loc.errorAmountMustBePositive;
    }

    return null;
  }
}
