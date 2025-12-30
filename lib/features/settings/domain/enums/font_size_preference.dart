/// Font size preference for accessibility.
enum FontSizePreference {
  /// Smaller text size.
  small,

  /// Default text size.
  medium,

  /// Larger text size.
  large;

  static FontSizePreference fromString(String fontSize) {
    switch (fontSize) {
      case 'small':
        return FontSizePreference.small;
      case 'medium':
        return FontSizePreference.medium;
      case 'large':
        return FontSizePreference.large;
      default:
        return FontSizePreference.medium; // Default fallback
    }
  }
}
