import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppFormatters {
  static String formatCurrency(double value, String locale,
      {bool noSymbol = false}) {
    final format = NumberFormat.simpleCurrency(locale: locale);
    if (noSymbol) {
      return format.format(value).replaceAll(format.currencySymbol, '').trim();
    }
    return format.format(value);
  }

  static String formatDateShort(DateTime date, String locale) {
    return DateFormat.Md(locale).format(date);
  }

  static double getCurrencyValue(String formatted, String locale) {
    final format = NumberFormat.simpleCurrency(locale: locale);
    String cleaned = formatted.replaceAll(format.currencySymbol, '').trim();
    cleaned = cleaned.replaceAll(format.symbols.GROUP_SEP, '');
    cleaned = cleaned.replaceAll(format.symbols.DECIMAL_SEP, '.');
    return double.tryParse(cleaned) ?? 0.0;
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter;

  CurrencyInputFormatter({String? locale})
      : _formatter = NumberFormat.currency(
          locale: locale,
          symbol: '',
          decimalDigits: 2,
        );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 1. Remove everything that is not a number
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // If it is empty, return empty
    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    double value = double.parse(newText) / 100;
    String formattedText = _formatter.format(value).trim();

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
