import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../enums/settings_enums.dart';

/// Entity representing user appearance preferences.
///
/// Immutable data class that holds all appearance-related settings.
/// Uses [Equatable] for value-based equality comparison.
class AppearancePreferences extends Equatable {
  final AppThemeMode themeMode;
  final ColorBlindMode colorBlindMode;
  final CurrencyFormat currencyFormat;
  final FontSizePreference fontSize;
  final bool hideValues;
  final bool enableAnimations;

  const AppearancePreferences({
    this.themeMode = AppThemeMode.system,
    this.colorBlindMode = ColorBlindMode.none,
    this.currencyFormat = CurrencyFormat.symbol,
    this.fontSize = FontSizePreference.medium,
    this.hideValues = false,
    this.enableAnimations = true,
  });

  /// Creates a copy with the given fields replaced.
  AppearancePreferences copyWith({
    AppThemeMode? themeMode,
    ColorBlindMode? colorBlindMode,
    CurrencyFormat? currencyFormat,
    FontSizePreference? fontSize,
    bool? hideValues,
    bool? enableAnimations,
  }) {
    return AppearancePreferences(
      themeMode: themeMode ?? this.themeMode,
      colorBlindMode: colorBlindMode ?? this.colorBlindMode,
      currencyFormat: currencyFormat ?? this.currencyFormat,
      fontSize: fontSize ?? this.fontSize,
      hideValues: hideValues ?? this.hideValues,
      enableAnimations: enableAnimations ?? this.enableAnimations,
    );
  }

  /// Converts theme mode to Flutter's [ThemeMode].
  ThemeMode get flutterThemeMode {
    switch (themeMode) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  @override
  List<Object?> get props => [
        themeMode,
        colorBlindMode,
        currencyFormat,
        fontSize,
        hideValues,
        enableAnimations,
      ];
}
