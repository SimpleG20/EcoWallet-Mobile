/// Color blind accessibility modes.
enum ColorBlindMode {
  /// No color adjustment.
  none,

  /// Red-green color blindness (red weak).
  protanopia,

  /// Red-green color blindness (green weak).
  deuteranopia,

  /// Blue-yellow color blindness.
  tritanopia;

  static ColorBlindMode fromString(String colorBlindMode) {
    switch (colorBlindMode) {
      case 'protanopia':
        return ColorBlindMode.protanopia;
      case 'deuteranopia':
        return ColorBlindMode.deuteranopia;
      case 'tritanopia':
        return ColorBlindMode.tritanopia;
      case 'none':
      default:
        return ColorBlindMode.none;
    }
  }
}
