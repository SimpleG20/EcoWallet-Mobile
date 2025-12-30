import 'package:flutter/material.dart';

import '../../../../../core/constants/ui_data.dart';
import '../../../../../core/utils/app_formatters.dart';
import '../../../../../l10n/app_localizations.dart';

/// Main section of the balance card showing total balance and monthly savings.
class BalanceMainSection extends StatelessWidget {
  const BalanceMainSection({
    super.key,
    required this.totalBalance,
    required this.monthlySavings,
    required this.onToggleSection,
  });

  final double totalBalance;
  final double monthlySavings;
  final VoidCallback onToggleSection;

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
          _buildBalanceSection(theme, loc),
          const SizedBox(height: 20),
          _buildSavingsSection(theme, loc),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(ThemeData theme, AppLocalizations loc) {
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
        Text(
          AppFormatters.formatCurrency(totalBalance, loc.localeName),
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsSection(ThemeData theme, AppLocalizations loc) {
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
            Text(
              AppFormatters.formatCurrency(monthlySavings, loc.localeName),
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
