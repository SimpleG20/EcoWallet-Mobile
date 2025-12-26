import 'package:flutter/material.dart';

import 'package:eco_wallet/l10n/app_localizations.dart';
import 'package:eco_wallet/core/utils/app_formatters.dart';
import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard(
      {super.key, required this.transaction, required this.onTap});

  final Transaction transaction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isIncome = transaction.type == ETransactionType.income;
    double value = transaction.amount + transaction.cents / 100;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: isIncome
            ? theme.colorScheme.primary.withAlpha(50)
            : theme.colorScheme.outlineVariant.withAlpha(80),
        foregroundColor: isIncome
            ? theme.colorScheme.primary
            : theme.colorScheme.outlineVariant,
        child: Icon(transaction.type == ETransactionType.income
            ? Icons.trending_up
            : IconsMap.getCategoryIcon(transaction.category)),
      ),
      title: Text(transaction.name),
      subtitle: Text(transaction.category.isNotEmpty
          ? transaction.category
          : loc!.lbUncategorized),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(AppFormatters.formatCurrency(value, loc!.localeName),
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: isIncome
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant)),
          Text(
            AppFormatters.formatDateShort(transaction.date, loc.localeName),
            style: theme.textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}

class IconsMap {
  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.fastfood;
      case 'Transport':
        return Icons.directions_car;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Salary':
        return Icons.attach_money;
      case 'Entertainment':
        return Icons.movie;
      default:
        return Icons.category;
    }
  }
}
