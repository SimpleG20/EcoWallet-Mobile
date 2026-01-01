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
    final themeMode = json['themeMode'];
    final colorBlindMode = json['colorBlindMode'];
    final currencyFormat = json['currencyFormat'];
    final fontSize = json['fontSize'];
    final enableAnimations = int.tryParse(json['enableAnimations']) == 1;
    final hideValues = int.tryParse(json['hideValues']) == 1;

    return AppearancePreferencesModel(
      colorBlindMode: ColorBlindMode.fromString(colorBlindMode),
      currencyFormat: CurrencyFormat.fromString(currencyFormat),
      fontSize: FontSizePreference.fromString(fontSize),
      themeMode: AppThemeMode.fromString(themeMode),
      enableAnimations: enableAnimations,
      hideValues: hideValues,
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
