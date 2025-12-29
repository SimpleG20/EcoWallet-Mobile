/// Currency display format preference.
enum CurrencyFormat {
  /// Display currency symbol (e.g., $, R$).
  symbol,

  /// Display currency code (e.g., USD, BRL).
  code,
}

extension CurrencyFormatX on CurrencyFormat {
  String get displayName {
    switch (this) {
      case CurrencyFormat.symbol:
        return 'Symbol (R\$)';
      case CurrencyFormat.code:
        return 'Code (BRL)';
    }
  }
}
