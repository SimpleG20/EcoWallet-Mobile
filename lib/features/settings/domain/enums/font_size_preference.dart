/// Font size preference for accessibility.
enum FontSizePreference {
  /// Smaller text size.
  small,

  /// Default text size.
  medium,

  /// Larger text size.
  large,
}

extension FontSizePreferenceX on FontSizePreference {
  String get displayName {
    switch (this) {
      case FontSizePreference.small:
        return 'Small';
      case FontSizePreference.medium:
        return 'Medium';
      case FontSizePreference.large:
        return 'Large';
    }
  }

  double get scaleFactor {
    switch (this) {
      case FontSizePreference.small:
        return 0.85;
      case FontSizePreference.medium:
        return 1.0;
      case FontSizePreference.large:
        return 1.15;
    }
  }
}
