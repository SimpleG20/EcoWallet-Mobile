import 'package:eco_wallet/features/settings/domain/entities/settings_entities.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/ui_data.dart';
import '../../../../../core/presentation/widgets/sensitive_text.dart';
import '../../../../../core/utils/app_formatters.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../settings/domain/enums/currency_format.dart';

/// Main section of the balance card showing total balance and monthly savings.
class BalanceMainSection extends StatelessWidget {
  const BalanceMainSection({
    super.key,
    required this.appearancePreferences,
    required this.totalBalance,
    required this.monthlySavings,
    required this.onToggleSection,
  });

  final double totalBalance;
  final double monthlySavings;
  final VoidCallback onToggleSection;
  final AppearancePreferences appearancePreferences;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Container(
      height: kBalanceCardHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBalanceSection(theme, loc, appearancePreferences.currencyFormat),
          const SizedBox(height: 20),
          _buildSavingsSection(theme, loc, appearancePreferences.currencyFormat),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(ThemeData theme, AppLocalizations loc, CurrencyFormat currencyFormat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.dashboardTotalBalance,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 4),
        SensitiveText(
          text: AppFormatters.formatCurrencyWithPreference(totalBalance, currencyFormat, loc.localeName),
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsSection(ThemeData theme, AppLocalizations loc, CurrencyFormat currencyFormat) {
    final savingsTextStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onPrimaryContainer,
    );

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: theme.colorScheme.onPrimaryContainer.withAlpha(50),
          child: Icon(
            Icons.trending_up,
            size: kBalanceCardIconSize,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.dashboardMonthlySavings, style: savingsTextStyle),
            SensitiveText(
              text: AppFormatters.formatCurrencyWithPreference(monthlySavings, currencyFormat, loc.localeName),
              style: savingsTextStyle,
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: onToggleSection,
          icon: Icon(
            Icons.arrow_forward_ios,
            size: kBalanceCardIconSize,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
