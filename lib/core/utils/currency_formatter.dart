import 'package:intl/intl.dart';

/// Utility class for currency formatting
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format amount to currency string with symbol
  static String format(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Format amount to compact currency string (e.g., "$1.2K", "$1.5M")
  static String formatCompact(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.compactCurrency(
      symbol: symbol,
      decimalDigits: 1,
    );
    return formatter.format(amount);
  }

  /// Format amount without symbol
  static String formatWithoutSymbol(double amount) {
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: 2,
    );
    return formatter.format(amount).trim();
  }

  /// Parse currency string to double
  static double parse(String amountString) {
    final cleanString = amountString.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleanString) ?? 0.0;
  }
}
