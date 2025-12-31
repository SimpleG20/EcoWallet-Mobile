import 'package:eco_wallet/core/utils/app_formatters.dart';
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

    final parsedValue = AppFormatters.getCurrencyValue(value, loc.localeName);

    if (parsedValue <= 0) {
      return loc.errorAmountMustBePositive;
    }

    return null;
  }

  static String? isValidEmail(String? value, AppLocalizations loc) {
    if (value == null || value.isEmpty) {
      return loc.errorEmailEmpty;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return loc.errorEmailInvalid;
    }
    return null;
  }

  static String? isValidPassword(String? value, AppLocalizations loc) {
    if (value == null || value.isEmpty) {
      return loc.errorPasswordEmpty;
    }
    if (value.length < 8) {
      return loc.errorPasswordTooShort;
    }
    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasLowercase = value.contains(RegExp(r'[a-z]'));
    final hasDigit = value.contains(RegExp(r'\d'));
    final hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase || !hasLowercase || !hasDigit || !hasSpecialChar) {
      return loc.errorPasswordWeak;
    }
    return null;
  }

  static String? isValidPhoneNumber(String? value, AppLocalizations loc) {
    if (value == null || value.isEmpty) {
      return loc.errorPhoneEmpty;
    }

    final phoneRegex = RegExp(r'^(\+\d{1,2}\s?)?\d{1,4}[\s.-]?\d{1,4}[\s.-]?\d{1,4}[\s.-]?\d{1,4}$');
    if (!phoneRegex.hasMatch(value)) {
      return loc.errorPhoneInvalid;
    }
    return null;
  }

  static String? isValidAddress(AppLocalizations loc, String? value) {
    if (value == null || value.isEmpty) {
      return loc.errorAddressEmpty;
    }
    if (value.length < 5) {
      return loc.errorAddressInvalid;
    }
    return null;
  }

  static String? isValidDate(AppLocalizations loc, String? value) {
    if (value == null || value.isEmpty) {
      return loc.errorDateEmpty;
    }
    try {
      final parts = value.split('/');
      if (parts.length != 3) {
        return loc.errorDateInvalid;
      }

      var minDate = DateTime.now().subtract(const Duration(days: 365 * 120));
      var maxDate = DateTime.now().subtract(const Duration(days: 365 * 0));

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final date = DateTime(year, month, day);
      if (date.year != year || date.month != month || date.day != day) {
        return loc.errorDateInvalid;
      }

      if (date.isBefore(minDate) || date.isAfter(maxDate)) {
        return loc.errorDateOutOfRange;
      }
    } catch (e) {
      return loc.errorDateInvalid;
    }
    return null;
  }

  static String? isValidName(AppLocalizations loc, String? value) {
    if (value == null || value.isEmpty) {
      return loc.errorNameEmpty;
    }
    if (value.length < 2) {
      return loc.errorNameInvalid;
    }
    return null;
  }
}
