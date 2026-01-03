import 'package:eco_wallet/features/settings/domain/entities/settings_entities.dart';
import 'package:eco_wallet/features/settings/domain/enums/settings_enums.dart';

class AppearancePreferencesModel extends AppearancePreferences {
  const AppearancePreferencesModel({
    required super.themeMode,
    required super.colorBlindMode,
    required super.currencyFormat,
    required super.fontSize,
    required super.hideValues,
    required super.enableAnimations,
  });

  factory AppearancePreferencesModel.defaults() {
    return const AppearancePreferencesModel(
      themeMode: AppThemeMode.system,
      colorBlindMode: ColorBlindMode.none,
      currencyFormat: CurrencyFormat.symbol,
      fontSize: FontSizePreference.medium,
      hideValues: false,
      enableAnimations: true,
    );
  }

  factory AppearancePreferencesModel.fromJson(Map<String, dynamic> json) {
    final themeMode = json['themeMode']?.toString() ?? 'system';
    final colorBlindMode = json['colorBlindMode']?.toString() ?? 'none';
    final currencyFormat = json['currencyFormat']?.toString() ?? 'symbol';
    final fontSize = json['fontSize']?.toString() ?? 'medium';
    final enableAnimations = _parseBool(json['enableAnimations'], true);
    final hideValues = _parseBool(json['hideValues'], false);

    return AppearancePreferencesModel(
      colorBlindMode: ColorBlindMode.fromString(colorBlindMode),
      currencyFormat: CurrencyFormat.fromString(currencyFormat),
      fontSize: FontSizePreference.fromString(fontSize),
      themeMode: AppThemeMode.fromString(themeMode),
      enableAnimations: enableAnimations,
      hideValues: hideValues,
    );
  }

  /// Parses a boolean value from JSON that may be a bool, int (0/1), or string.
  static bool _parseBool(dynamic value, bool defaultValue) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return int.tryParse(value) == 1 || value.toLowerCase() == 'true';
    return defaultValue;
  }

  static Map<String, dynamic> toJson(AppearancePreferences preferences) {
    return {
      'themeMode': preferences.themeMode.name,
      'colorBlindMode': preferences.colorBlindMode.name,
      'currencyFormat': preferences.currencyFormat.name,
      'fontSize': preferences.fontSize.name,
      'hideValues': preferences.hideValues,
      'enableAnimations': preferences.enableAnimations,
    };
  }
}
