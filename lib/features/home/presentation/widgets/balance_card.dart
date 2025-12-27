import 'package:flutter/material.dart';
import 'package:eco_wallet/core/theme/app_colors.dart';
import 'package:eco_wallet/core/utils/app_formatters.dart';

/// Card widget displaying total balance and monthly savings.
/// 
/// Features a colored background with shadow and displays:
/// - Total balance amount
/// - Monthly savings with trend indicator
class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.monthlySavings,
    required this.locale,
    required this.balanceLabel,
    required this.savingsLabel,
  });

  final double totalBalance;
  final double monthlySavings;
  final String locale;
  final String balanceLabel;
  final String savingsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkCard.withAlpha(50),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBalanceSection(theme),
          const SizedBox(height: 20),
          _buildSavingsSection(theme),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          balanceLabel,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppFormatters.formatCurrency(totalBalance, locale),
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsSection(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: theme.colorScheme.onPrimaryContainer.withAlpha(50),
          child: const Icon(Icons.trending_up, size: 20),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              savingsLabel,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              AppFormatters.formatCurrency(monthlySavings, locale),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
