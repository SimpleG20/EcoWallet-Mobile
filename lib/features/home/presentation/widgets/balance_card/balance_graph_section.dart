import 'package:flutter/material.dart';

import '../../../../../core/constants/ui_data.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/weekly_transaction_data.dart';
import 'weekly_bar_chart.dart';

/// Graph section of the balance card showing weekly transaction overview.
class BalanceGraphSection extends StatelessWidget {
  const BalanceGraphSection({
    super.key,
    required this.weeklyData,
    required this.onBackPressed,
  });

  final WeeklyTransactionData weeklyData;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Container(
      height: kBalanceCardHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, theme, loc),
          const SizedBox(height: 4),
          Expanded(
            child: WeeklyBarChart(weeklyData: weeklyData),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        IconButton(
          onPressed: onBackPressed,
          icon: Icon(
            Icons.arrow_back_ios,
            size: kBalanceCardIconSize,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          loc.dashboardWeeklyOverview,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => _showInfoDialog(context, loc),
          icon: Icon(
            Icons.info_outline,
            size: 24,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
        actionsPadding: const EdgeInsets.all(8.0),
        content: Text(loc.dashboardWeeklyOverviewInfo),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
  }
}
