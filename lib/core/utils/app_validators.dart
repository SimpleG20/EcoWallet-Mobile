import 'package:eco_wallet/core/utils/app_formatters.dart';
import 'package:eco_wallet/l10n/app_localizations.dart';

class AppValidators {
  static String? validateTitle(String? value, AppLocalizations loc) {
    if (value == null || value.trim().isEmpty) {
      return loc.errorEmpty;
    }
    return null;
  }

  static String? validateAmount(AppLocalizations loc, String? value, {String? output}) {
    if (value == null || value.isEmpty) {
      return output ?? loc.errorEmpty;
    }

    final parsedValue = AppFormatters.getCurrencyValue(value, loc.localeName);

    if (parsedValue <= 0) {
      return output ?? loc.errorAmountMustBePositive;
    }

    return null;
  }

  static String? isValidEmail(AppLocalizations loc, String? value, {String? output}) {
    if (value == null || value.isEmpty) {
      return loc.errorEmpty;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return output ?? loc.errorEmailInvalid;
    }
    return null;
  }

  static String? isValidPassword(AppLocalizations loc, String? value, {String? output}) {
    if (value == null || value.isEmpty) {
      return loc.errorEmpty;
    }
    if (value.length < 8) {
      return output ?? loc.errorPasswordTooShort;
    }
    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasLowercase = value.contains(RegExp(r'[a-z]'));
    final hasDigit = value.contains(RegExp(r'\d'));
    final hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase || !hasLowercase || !hasDigit || !hasSpecialChar) {
      return output ?? loc.errorPasswordWeak;
    }
    return null;
  }

  static String? isValidPhoneNumber(AppLocalizations loc, String? value, {String? output}) {
    if (value == null || value.isEmpty) {
      return loc.errorEmpty;
    }

    final phoneRegex = RegExp(r'^(\+\d{1,2}\s?)?\d{1,4}[\s.-]?\d{1,4}[\s.-]?\d{1,4}[\s.-]?\d{1,4}$');
    if (!phoneRegex.hasMatch(value)) {
      return output ?? loc.errorPhoneInvalid;
    }
    return null;
  }

  static String? isValidAddress(AppLocalizations loc, String? value, {String? output}) {
    if (value == null || value.isEmpty) {
      return loc.errorEmpty;
    }
    if (value.length < 5) {
      return output ?? loc.errorAddressInvalid;
    }
    return null;
  }

  static String? isValidDate(AppLocalizations loc, String? value, {String? output}) {
    if (value == null || value.isEmpty) {
      return loc.errorEmpty;
    }
    try {
      final parts = value.split('/');
      if (parts.length != 3) {
        return output ?? loc.errorDateInvalid;
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

  static String? isValidName(AppLocalizations loc, String? value, {String? output}) {
    if (value == null || value.isEmpty) {
      return loc.errorEmpty;
    }
    if (value.length < 2) {
      return output ?? loc.errorNameInvalid;
    }
    return null;
  }

  static String? isValidPercentage(AppLocalizations loc, String? value, {String? output}) {
    if (value == null || value.isEmpty) {
      return loc.errorEmpty;
    }
    final number = int.tryParse(value);
    if (number == null || number < 0 || number > 100) {
      return output ?? loc.errorPercentageInvalid;
    }
    return null;
  }
}
