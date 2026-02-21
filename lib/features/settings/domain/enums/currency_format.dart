/// Currency display format preference.
enum CurrencyFormat {
  /// Display currency symbol (e.g., $, R$).
  symbol,

  /// Display currency code (e.g., USD, BRL).
  code;

  static CurrencyFormat fromString(String currencyFormat) {
    return CurrencyFormat.values.firstWhere(
      (e) => e.toString() == currencyFormat || e.name == currencyFormat,
      orElse: () => CurrencyFormat.symbol,
    );
  }
}
