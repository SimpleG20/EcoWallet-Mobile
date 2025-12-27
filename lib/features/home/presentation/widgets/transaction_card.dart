import 'package:flutter/material.dart';

import 'package:eco_wallet/l10n/app_localizations.dart';
import 'package:eco_wallet/core/utils/app_formatters.dart';
import 'package:eco_wallet/core/constants/category_data.dart';
import 'package:eco_wallet/features/wallet/domain/entities/transaction.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard(
      {super.key,
      required this.transaction,
      required this.onTap,
      this.blackAndWhite = false});

  final Transaction transaction;
  final VoidCallback onTap;
  final bool blackAndWhite;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isIncome = transaction.type == ETransactionType.income;
    double value = transaction.amount + transaction.cents / 100;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: isIncome
            ? theme.colorScheme.primary.withAlpha(50)
            : blackAndWhite
                ? theme.colorScheme.outlineVariant.withAlpha(80)
                : theme.colorScheme.error.withAlpha(80),
        foregroundColor: isIncome
            ? theme.colorScheme.primary
            : blackAndWhite
                ? theme.colorScheme.outlineVariant
                : theme.colorScheme.error,
        child: Icon(transaction.type == ETransactionType.income
            ? Icons.trending_up
            : CategoryRepository.getIconByLabel(transaction.category, loc)),
      ),
      title: Text(transaction.name),
      subtitle: Text(
          transaction.category.isNotEmpty
              ? transaction.category
              : loc.lbUncategorized,
          style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(150))),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(AppFormatters.formatCurrency(value, loc.localeName),
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
