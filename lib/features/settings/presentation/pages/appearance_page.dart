import 'package:eco_wallet/features/settings/domain/entities/settings_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_bloc.dart';
import '../widgets/settings_widgets.dart';
import '../../domain/enums/settings_enums.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/presentation/widgets/switch_row.dart';
import '../../../../core/presentation/widgets/dropdown_row.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  AppearancePreferences _currentPreferences = AppearancePreferences();
  late AppearancePreferences _initialPreferences;

  bool _pendingChanges = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final settingsState = context.read<SettingsBloc>().state;
    if (settingsState is! SettingsLoadedState) return;

    _initialPreferences = settingsState.preferences.appearancePreferences;
    _currentPreferences = _initialPreferences;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<SettingsBloc, BaseSettingsState>(
      buildWhen: (previous, current) {
        return current is SettingsLoadingState || current is SettingsErrorState || current is SettingsLoadedState;
      },
      builder: (context, state) {
        if (state is SettingsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SettingsErrorState) {
          return Center(child: Text(state.message ?? loc.errorUnknown));
        }

        if (state is SettingsLoadedState) {
          final confirmEditionBtn = SettingsConfirmEditionBtn(
            onPressed: (ctx) => _submitChanges(ctx),
            pendingChanges: _pendingChanges,
          );
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    SettingsSubPageHeader(
                      title: loc.lbAppearance,
                      subtitle: loc.appearanceSubTitle,
                      confirmEditionBtn: confirmEditionBtn,
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SettingsCard(
                        child: _buildOptions(context, theme, loc),
                      ),
                    ),
                  ],
                ),
                confirmEditionBtn,
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        SettingsSectionTitle(title: loc.sectionGeneral),
        const SizedBox(height: 8),
        DropdownRow<AppThemeMode>(
          icon: Icons.brightness_6,
          label: loc.lbTheme,
          value: _currentPreferences.themeMode,
          items: [
            DropdownMenuItem(value: AppThemeMode.system, child: Text(loc.themeSystem)),
            DropdownMenuItem(value: AppThemeMode.light, child: Text(loc.themeLight)),
            DropdownMenuItem(value: AppThemeMode.dark, child: Text(loc.themeDark)),
          ],
          onChanged: (v) => setState(() {
            _currentPreferences = _currentPreferences.copyWith(themeMode: v!);
            _submitChanges(context);
          }),
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
          value: _currentPreferences.currencyFormat,
          items: [
            DropdownMenuItem(value: CurrencyFormat.symbol, child: Text(loc.currencySymbol)),
            DropdownMenuItem(value: CurrencyFormat.code, child: Text(loc.currencyCode)),
          ],
          onChanged: (v) {
            setState(() {
              _currentPreferences = _currentPreferences.copyWith(currencyFormat: v!);
              _pendingChanges = _currentPreferences != _initialPreferences;
            });
          },
          theme: theme,
        ),
        SwitchRow(
          theme: theme,
          label: loc.lbHideValues,
          icon: _currentPreferences.hideValues ? Icons.visibility_off : Icons.visibility,
          value: _currentPreferences.hideValues,
          onChanged: (v) => setState(() {
            _currentPreferences = _currentPreferences.copyWith(hideValues: v);
            _pendingChanges = _currentPreferences != _initialPreferences;
          }),
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
      value: _currentPreferences.colorBlindMode,
      items: [
        DropdownMenuItem(value: ColorBlindMode.none, child: Text(loc.colorBlindNone)),
        DropdownMenuItem(value: ColorBlindMode.protanopia, child: Text(loc.colorBlindProtanopia)),
        DropdownMenuItem(value: ColorBlindMode.deuteranopia, child: Text(loc.colorBlindDeuteranopia)),
        DropdownMenuItem(value: ColorBlindMode.tritanopia, child: Text(loc.colorBlindTritanopia)),
      ],
      onChanged: (ColorBlindMode? newValue) {
        setState(() {
          _currentPreferences = _currentPreferences.copyWith(colorBlindMode: newValue!);
          _pendingChanges = _currentPreferences != _initialPreferences;
        });
      },
      theme: theme,
    );
  }

  Widget _buildAnimationsOption(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return SwitchRow(
      icon: Icons.auto_awesome,
      label: loc.lbAnimations,
      value: _currentPreferences.enableAnimations,
      onChanged: (bool newValue) {
        setState(() {
          _currentPreferences = _currentPreferences.copyWith(enableAnimations: newValue);
          _pendingChanges = _currentPreferences != _initialPreferences;
        });
      },
      theme: theme,
    );
  }

  Widget _buildFontsSizeOption(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return DropdownRow<FontSizePreference>(
      icon: Icons.text_fields,
      label: loc.lbFontSize,
      value: _currentPreferences.fontSize,
      items: [
        DropdownMenuItem(value: FontSizePreference.small, child: Text(loc.fontSizeSmall)),
        DropdownMenuItem(value: FontSizePreference.medium, child: Text(loc.fontSizeMedium)),
        DropdownMenuItem(value: FontSizePreference.large, child: Text(loc.fontSizeLarge)),
      ],
      onChanged: (FontSizePreference? newValue) {
        setState(() {
          _currentPreferences = _currentPreferences.copyWith(fontSize: newValue!);
          _pendingChanges = _currentPreferences != _initialPreferences;
        });
      },
      theme: theme,
    );
  }

  void _submitChanges(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    final currentState = bloc.state;

    if (currentState is SettingsLoadedState) {
      final updatedPreferences = currentState.preferences.copyWith(
        appearancePreferences: _currentPreferences,
      );

      _initialPreferences = _currentPreferences;
      _pendingChanges = false;

      bloc.add(UpdateUserPreferencesEvent(userPreferences: updatedPreferences));
    }
  }
}
