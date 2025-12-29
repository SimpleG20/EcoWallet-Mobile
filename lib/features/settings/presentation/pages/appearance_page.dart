import 'package:eco_wallet/features/settings/presentation/widgets/settings_sub_page_header.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

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
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: [
        _buildSectionTitle(theme, "Geral"), // Add to arb
        _OptionRow<EAppThemeMode>(
          icon: Icons.brightness_6,
          label: loc.lbTheme,
          value: _selectedTheme,
          items: const [
            DropdownMenuItem(value: EAppThemeMode.system, child: Text("Sistema")),
            DropdownMenuItem(value: EAppThemeMode.light, child: Text("Claro")),
            DropdownMenuItem(value: EAppThemeMode.dark, child: Text("Escuro")),
          ],
          onChanged: (v) => setState(() => _selectedTheme = v!),
          theme: theme,
        ),

        _buildSectionTitle(theme, "Display"),

        _OptionRow<ECurrencyFormat>(
          icon: Icons.attach_money,
          label: "Formato Moeda", // Add to arb: loc.lbCurrencyFormat
          value: _currencyFormat,
          items: const [
            DropdownMenuItem(value: ECurrencyFormat.symbol, child: Text("Símbolo (R\$)")),
            DropdownMenuItem(value: ECurrencyFormat.code, child: Text("Código (BRL)")),
          ],
          onChanged: (v) => setState(() => _currencyFormat = v!),
          theme: theme,
        ),
        _Separator(theme: theme),

        _SwitchRow(
          icon: _hideCurrency ? Icons.visibility_off : Icons.visibility,
          label: "Ocultar Valores", // Add to arb: loc.lbHideCurrency
          value: _hideCurrency,
          onChanged: (v) => setState(() => _hideCurrency = v),
          theme: theme,
        ),

        _buildSectionTitle(theme, "Performance & Acessibilidade"),
        _OptionRow<EColorBlindMode>(
          icon: Icons.color_lens_outlined,
          label: "Daltonismo", // Add to arb: loc.lbColorBlind
          value: _colorBlindMode,
          items: const [
            DropdownMenuItem(value: EColorBlindMode.none, child: Text("Nenhum")),
            DropdownMenuItem(value: EColorBlindMode.protanopia, child: Text("Protanopia")),
            DropdownMenuItem(value: EColorBlindMode.deuteranopia, child: Text("Deuteranopia")),
            DropdownMenuItem(value: EColorBlindMode.tritanopia, child: Text("Tritanopia")),
          ],
          onChanged: (v) => setState(() => _colorBlindMode = v!),
          theme: theme,
        ),
        _Separator(theme: theme),

        _SwitchRow(
          icon: Icons.auto_awesome,
          label: "Animações", // Add to arb: loc.lbAnimations
          value: _enableAnimations,
          onChanged: (v) => setState(() => _enableAnimations = v),
          theme: theme,
        ),
        _Separator(theme: theme),

        _OptionRow<EFontSize>(
          icon: Icons.text_fields,
          label: "Tamanho Fonte", // Add to arb: loc.lbFontSize
          value: _fontSize,
          items: const [
            DropdownMenuItem(value: EFontSize.small, child: Text("Pequena")),
            DropdownMenuItem(value: EFontSize.medium, child: Text("Média")),
            DropdownMenuItem(value: EFontSize.large, child: Text("Grande")),
          ],
          onChanged: (v) => setState(() => _fontSize = v!),
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// --- Reusable Widgets to enforce DRY and Consistency ---

class _OptionRow<T> extends StatelessWidget {
  final IconData icon;
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final ThemeData theme;

  const _OptionRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final ThemeData theme;

  const _SwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0), // Less padding for switch
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  final ThemeData theme;
  const _Separator({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
      indent: 56, // Align with text start
      endIndent: 16,
      height: 1,
    );
  }
}
