/// Color blind accessibility modes.
enum ColorBlindMode {
  /// No color adjustment.
  none,

  /// Red-green color blindness (red weak).
  protanopia,

  /// Red-green color blindness (green weak).
  deuteranopia,

  /// Blue-yellow color blindness.
  tritanopia,
}

extension ColorBlindModeX on ColorBlindMode {
  String get displayName {
    switch (this) {
      case ColorBlindMode.none:
        return 'None';
      case ColorBlindMode.protanopia:
        return 'Protanopia';
      case ColorBlindMode.deuteranopia:
        return 'Deuteranopia';
      case ColorBlindMode.tritanopia:
        return 'Tritanopia';
    }
  }
}
