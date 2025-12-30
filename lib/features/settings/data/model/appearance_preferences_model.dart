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

  factory AppearancePreferencesModel.fromJson(Map<String, dynamic> json) {
    final themeMode = json['themeMode'] as String;
    final colorBlindMode = json['colorBlindMode'] as String;
    final currencyFormat = json['currencyFormat'] as String;
    final fontSize = json['fontSize'] as String;
    final enableAnimations = json['enableAnimations'] as bool;
    final hideValues = json['hideValues'] as bool;

    return AppearancePreferencesModel(
      colorBlindMode: ColorBlindMode.fromString(colorBlindMode),
      currencyFormat: CurrencyFormat.fromString(currencyFormat),
      enableAnimations: enableAnimations,
      fontSize: FontSizePreference.fromString(fontSize),
      hideValues: hideValues,
      themeMode: AppThemeMode.fromString(themeMode),
    );
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
