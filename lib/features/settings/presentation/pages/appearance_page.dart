import 'package:eco_wallet/core/presentation/widgets/dropdown_row.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_section_list.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_card.dart';
import 'package:eco_wallet/features/settings/domain/enums/settings_enums.dart';
import 'package:flutter/material.dart';

import '../widgets/settings_section_title.dart';
import '../widgets/settings_sub_page_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/presentation/widgets/switch_row.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  AppThemeMode _selectedTheme = AppThemeMode.system;
  ColorBlindMode _colorBlindMode = ColorBlindMode.none;
  CurrencyFormat _currencyFormat = CurrencyFormat.symbol;
  FontSizePreference _fontSize = FontSizePreference.medium;
  bool _hideCurrency = false;
  bool _enableAnimations = true;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Column(
      children: [
        SettingsSubPageHeader(
          title: loc.lbAppearance,
          subtitle: loc.appearanceSubTitle,
          complement: null,
        ),
        const SizedBox(height: 24),
        Expanded(
          child: SettingsCard(
            child: _buildOptions(context, theme, loc),
          ),
        ),
      ],
    );
  }

  Widget _buildOptions(BuildContext context, ThemeData theme, AppLocalizations loc) {
    final sections = [
      _buildGeneralSection(context, theme, loc),
      _buildDisplaySection(context, theme, loc),
      _buildAccessibilitySection(context, theme, loc),
    ];
    return SettingsSectionList(sections: sections, theme: theme);
  }

  Widget _buildGeneralSection(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        SettingsSectionTitle(title: loc.sectionGeneral),
        const SizedBox(height: 8),
        DropdownRow<AppThemeMode>(
          icon: Icons.brightness_6,
          label: loc.lbTheme,
          value: _selectedTheme,
          items: [
            DropdownMenuItem(value: AppThemeMode.system, child: Text(loc.themeSystem)),
            DropdownMenuItem(value: AppThemeMode.light, child: Text(loc.themeLight)),
            DropdownMenuItem(value: AppThemeMode.dark, child: Text(loc.themeDark)),
          ],
          onChanged: (v) => setState(() => _selectedTheme = v!),
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildDisplaySection(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: loc.sectionDisplay),
        const SizedBox(height: 8),
        DropdownRow<CurrencyFormat>(
          icon: Icons.attach_money,
          label: loc.lbCurrencyFormat,
          value: _currencyFormat,
          items: [
            DropdownMenuItem(value: CurrencyFormat.symbol, child: Text(loc.currencySymbol)),
            DropdownMenuItem(value: CurrencyFormat.code, child: Text(loc.currencyCode)),
          ],
          onChanged: (v) => setState(() => _currencyFormat = v!),
          theme: theme,
        ),
        SwitchRow(
          icon: _hideCurrency ? Icons.visibility_off : Icons.visibility,
          label: loc.lbHideValues,
          value: _hideCurrency,
          onChanged: (v) => setState(() => _hideCurrency = v),
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildAccessibilitySection(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionTitle(title: loc.sectionAccessibility),
        const SizedBox(height: 8),
        _buildColorBlindModeOption(context, theme, loc),
        _buildAnimationsOption(context, theme, loc),
        _buildFontsSizeOption(context, theme, loc),
      ],
    );
  }

  Widget _buildColorBlindModeOption(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return DropdownRow<ColorBlindMode>(
      icon: Icons.color_lens_outlined,
      label: loc.lbColorBlindMode,
      value: _colorBlindMode,
      items: [
        DropdownMenuItem(value: ColorBlindMode.none, child: Text(loc.colorBlindNone)),
        DropdownMenuItem(value: ColorBlindMode.protanopia, child: Text(loc.colorBlindProtanopia)),
        DropdownMenuItem(value: ColorBlindMode.deuteranopia, child: Text(loc.colorBlindDeuteranopia)),
        DropdownMenuItem(value: ColorBlindMode.tritanopia, child: Text(loc.colorBlindTritanopia)),
      ],
      onChanged: (ColorBlindMode? newValue) {
        setState(() {
          _colorBlindMode = newValue!;
        });
      },
      theme: theme,
    );
  }

  Widget _buildAnimationsOption(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return SwitchRow(
      icon: Icons.auto_awesome,
      label: loc.lbAnimations,
      value: _enableAnimations,
      onChanged: (bool newValue) {
        setState(() {
          _enableAnimations = newValue;
        });
      },
      theme: theme,
    );
  }

  Widget _buildFontsSizeOption(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return DropdownRow<FontSizePreference>(
      icon: Icons.text_fields,
      label: loc.lbFontSize,
      value: _fontSize,
      items: [
        DropdownMenuItem(value: FontSizePreference.small, child: Text(loc.fontSizeSmall)),
        DropdownMenuItem(value: FontSizePreference.medium, child: Text(loc.fontSizeMedium)),
        DropdownMenuItem(value: FontSizePreference.large, child: Text(loc.fontSizeLarge)),
      ],
      onChanged: (FontSizePreference? newValue) {
        setState(() {
          _fontSize = newValue!;
        });
      },
      theme: theme,
    );
  }
}
