import 'package:eco_wallet/core/presentation/widgets/dropdown_row.dart';
import 'package:eco_wallet/features/settings/presentation/widgets/settings_section_list.dart';
import 'package:flutter/material.dart';

import '../widgets/settings_section_title.dart';
import '../widgets/settings_sub_page_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/presentation/widgets/switch_row.dart';

enum EAppThemeMode { system, light, dark }

enum EColorBlindMode { none, protanopia, deuteranopia, tritanopia }

enum ECurrencyFormat { symbol, code }

enum EFontSize { small, medium, large }

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  EAppThemeMode _selectedTheme = EAppThemeMode.system;
  EColorBlindMode _colorBlindMode = EColorBlindMode.none;
  ECurrencyFormat _currencyFormat = ECurrencyFormat.symbol;
  EFontSize _fontSize = EFontSize.medium;
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
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
            clipBehavior: Clip.hardEdge,
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
        DropdownRow<EAppThemeMode>(
          icon: Icons.brightness_6,
          label: loc.lbTheme,
          value: _selectedTheme,
          items: [
            DropdownMenuItem(value: EAppThemeMode.system, child: Text(loc.themeSystem)),
            DropdownMenuItem(value: EAppThemeMode.light, child: Text(loc.themeLight)),
            DropdownMenuItem(value: EAppThemeMode.dark, child: Text(loc.themeDark)),
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
        DropdownRow<ECurrencyFormat>(
          icon: Icons.attach_money,
          label: loc.lbCurrencyFormat,
          value: _currencyFormat,
          items: [
            DropdownMenuItem(value: ECurrencyFormat.symbol, child: Text(loc.currencySymbol)),
            DropdownMenuItem(value: ECurrencyFormat.code, child: Text(loc.currencyCode)),
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
    return DropdownRow<EColorBlindMode>(
      icon: Icons.color_lens_outlined,
      label: loc.lbColorBlindMode,
      value: _colorBlindMode,
      items: [
        DropdownMenuItem(value: EColorBlindMode.none, child: Text(loc.colorBlindNone)),
        DropdownMenuItem(value: EColorBlindMode.protanopia, child: Text(loc.colorBlindProtanopia)),
        DropdownMenuItem(value: EColorBlindMode.deuteranopia, child: Text(loc.colorBlindDeuteranopia)),
        DropdownMenuItem(value: EColorBlindMode.tritanopia, child: Text(loc.colorBlindTritanopia)),
      ],
      onChanged: (EColorBlindMode? newValue) {
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
    return DropdownRow<EFontSize>(
      icon: Icons.text_fields,
      label: loc.lbFontSize,
      value: _fontSize,
      items: [
        DropdownMenuItem(value: EFontSize.small, child: Text(loc.fontSizeSmall)),
        DropdownMenuItem(value: EFontSize.medium, child: Text(loc.fontSizeMedium)),
        DropdownMenuItem(value: EFontSize.large, child: Text(loc.fontSizeLarge)),
      ],
      onChanged: (EFontSize? newValue) {
        setState(() {
          _fontSize = newValue!;
        });
      },
      theme: theme,
    );
  }
}
